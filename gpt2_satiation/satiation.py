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
import evaluate
import wandb

import os, sys
os.environ["TOKENIZERS_PARALLELISM"] = "false"


def main():
    # Import datasets
    data_files = {"train": "datasets/gen_POLAR_train10.txt", "test": "datasets/gen_POLAR_test15.txt"}
    polar_10 = load_dataset("text", data_files=data_files)
    run_name = "polar_10"

    # Setting up model, tokenizer, training arguments
    tokenizer = AutoTokenizer.from_pretrained('gpt2')
    model = AutoModelForCausalLM.from_pretrained('gpt2')

    def tokenize_function(examples):
        return tokenizer(examples['text'], truncation=True, padding=True)
    tokenizer.pad_token = tokenizer.eos_token
    tokenized_datasets = polar_10.map(tokenize_function, batched=True, remove_columns=["text"])
    tokenized_datasets.set_format(type = "torch")
    data_collator = LMDataCollator(tokenizer=tokenizer)
    print(tokenized_datasets['train'][0])
    #data_collator = DefaultDataCollator(tokenizer=tokenizer)

    # Setting up training arguments
    training_args = TrainingArguments(
        learning_rate=1e-3,
        run_name = run_name,
        output_dir="checkpoints/" + run_name,
        per_device_train_batch_size=1,
        per_device_eval_batch_size=1,
        evaluation_strategy='epoch',
        num_train_epochs=20,
        save_strategy='steps',
        save_steps=50,
        report_to = 'wandb',
        remove_unused_columns=False,
    )

    trainer = Trainer(
        args=training_args,
        model=model,
        train_dataset = tokenized_datasets['train'],
        eval_dataset = tokenized_datasets['test'],
        tokenizer=tokenizer,
        data_collator=data_collator,
        #compute_metrics = compute_metrics,
    )

    # Run training loop
    wandb.init(
        project="gpt2-satiation",
        name=run_name,
    )
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
    main()