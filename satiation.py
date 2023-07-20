from datasets import load_datasets, load_metric
from transformers import AutoTokenizer, AutoModelForCausalLM, Trainer, TrainingArguments
import wandb

# Import datasets
data_files = {"train": "gen_POLAR_train10.txt", "test": "gen_POLAR_test15.txt"}
wh_train_10_ds = load_dataset("/data/datasets/", data_files=data_files)

# Setting up model, tokenizer, training arguments
tokenizer = AutoTokenizer.from_pretrained('gpt2')
model = AutoModelForCausalLM.from_pretrained('gpt2')


def tokenize_function(examples):
    return tokenizer(examples["text"], padding="max_length", truncation=True)


tokenized_datasets = dataset.map(tokenize_function, batched=False)