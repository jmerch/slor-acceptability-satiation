import argparse
from dataclasses import dataclass
import torch
from datasets import load_dataset, load_metric
from transformers import (
    AutoTokenizer, 
    AutoModelForCausalLM, 
    Trainer,
    TrainingArguments, 
    DataCollatorForLanguageModeling,
    PreTrainedTokenizerBase,
    BatchEncoding)
from typing import Any, Callable, Dict, List, Optional, Tuple
from quinine import Quinfig
#import evaluate
import wandb

import os, sys
os.environ["TOKENIZERS_PARALLELISM"] = "false"
#condition = sys.argv[1].upper()
#num_training_sents = sys.argv[2]

def main(quinfig):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Using device: {device}")

    train_name = args.train_name
    test_name = args.test_name
    #num_training_sents = args.num_train
    print(f"train_name: {train_name}; test_name: {test_name}")
    
    # Import datasets
    #data_files = {"train": f"datasets/gen_{condition}_train{num_training_sents}.txt", "test": f"datasets/gen_{condition}_test15.txt"}
    data_files = {"train": f"datasets/{train_name}.txt", "test": f"datasets/{test_name}.txt"}
    dataset = load_dataset("text", data_files=data_files)

    # Setting up model, tokenizer, training arguments
    model = AutoModelForCausalLM.from_pretrained('gpt2')
    tokenizer = AutoTokenizer.from_pretrained('gpt2', use_fast=True)

    def tokenize_function(examples):
        return tokenizer(examples['text'], truncation=True, padding=True)
    tokenizer.pad_token = tokenizer.eos_token
    
    tokenized_datasets = dataset.map(tokenize_function, batched=True, remove_columns=["text"])
    tokenized_datasets.set_format(type = "torch")
    data_collator = LMDataCollator(tokenizer=tokenizer)

    # Setting up training arguments
    run_name = f"{train_name}_{quinfig.general.run_name}"
    training_args = TrainingArguments(
        run_name = run_name,
        output_dir=os.path.join(quinfig.general.save_dir, run_name),
        **quinfig.training.toDict()
    )
    trainer = Trainer(
        args=training_args,
        model=model,
        train_dataset = tokenized_datasets['train'],
        eval_dataset = tokenized_datasets['test'], # Is this what we want? Probably not
        tokenizer=tokenizer,
        data_collator=data_collator,
        #compute_metrics = compute_metrics,
    )

    # Run training loop
    wandb.init(
        project=quinfig.general.wandb_project,
        name=run_name,
    )
    print(f"Starting run: {run_name}")
    trainer.evaluate()
    trainer.train()
    wandb.finish()

# Lifted from mistral
@dataclass
class LMDataCollator:
    tokenizer: PreTrainedTokenizerBase

    def __call__(self, examples: List[BatchEncoding]):
        batch = BatchEncoding(data={k: torch.cat([v[k].unsqueeze(0) for v in examples]) for k in examples[0].keys()})

        if "labels" in batch:
            labels = batch["labels"]
        else:
            labels = batch["input_ids"]

        if self.tokenizer.pad_token_id is not None:
            labels = labels.clone()
            labels[labels == self.tokenizer.pad_token_id] = -100

        batch["labels"] = labels
        return batch

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", type=str) # specify path of config file
    parser.add_argument("--train_name", type=str)
    parser.add_argument("--test_name", type=str)
    #parser.add_argument("--num_train", type=int)
    args = parser.parse_args()
    quinfig = Quinfig(args.config)
    main(quinfig)