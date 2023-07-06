
import os, sys, torch, transformers, math
from transformers import AutoTokenizer, AutoModelForCausalLM, GPTNeoXTokenizerFast

def main():
    source = sys.argv[1]

    f = open(source)
    out = open("../data/surprisals.csv", "w")

    sentence_id = 2
    curr_total = 0
    exp_inc_total = 0
    exp_dec_total = 0
    exp_sum_total = 0
    normal_total = 0
    num_words = 0
    weight_total = 0
    #gauss_weight_total = 0
    surprisals = []
    words = []
    lines = f.readlines()
    lines.pop(0)
    out.write('"sentence_id","mean_surprisal","weight_first","weight_last","weight_sum","normalized"\n')
    
    unique_word_surprisal = {}
    for line in lines:
        data = line.strip().split(" ")
        word = data[0]
        if word not in unique_word_surprisal:
            unique_word_surprisal[word] = 0
    get_individual_surprisal(unique_word_surprisal, "gpt2")
    
    for line in lines:
        data = line.strip().split(" ")
        word = data[0]
        surprisal = float(data[1]) 
        num_words += 1
        surprisals.append(surprisal)
        words.append(word)
        if (word == '?'):
            for i in range(num_words):
                #gauss_weight = math.exp(-(i - (num_words / 2))**2)
                inc_weight = math.exp(-i)
                dec_weight = math.exp(-(num_words - i - 1))
                exp_inc_total += surprisals[i] * inc_weight
                exp_dec_total += surprisals[i] * dec_weight
                exp_sum_total += surprisals[i] * (inc_weight + dec_weight)
                curr_total += surprisals[i]
                #gauss_total += surprisals[i] * gauss_weight
                weight_total += inc_weight
                normal_total += surprisals[i] / unique_word_surprisal[words[i]]
                #gauss_weight_total += gauss_weight
            out.write(f'{sentence_id},{curr_total / num_words},{exp_inc_total / weight_total},{exp_dec_total / weight_total},{exp_sum_total / (weight_total * 2)},{normal_total / num_words}\n')
            sentence_id += 1
            curr_total = 0
            weight_total = 0
            exp_dec_total = 0
            exp_inc_total = 0
            exp_sum_total = 0
            normal_total = 0
            #gauss_weight_total = 0
            num_words = 0
            surprisals = []
            words = []



def get_individual_surprisal(surprisal_dict, model):
    model_variant = model
    if "gpt-neox" in model_variant:
        tokenizer = GPTNeoXTokenizerFast.from_pretrained(model)
    elif "gpt" in model_variant:
        tokenizer = AutoTokenizer.from_pretrained(model, use_fast=False)
    elif "opt" in model_variant:
        tokenizer = AutoTokenizer.from_pretrained(model, use_fast=False)
    else:
        raise ValueError("Unsupported LLM variant")
    model = AutoModelForCausalLM.from_pretrained(model)
    model.eval()
    softmax = torch.nn.Softmax(dim=-1)
    ctx_size = model.config.max_position_embeddings
    bos_id = model.config.bos_token_id

    for word in surprisal_dict.keys():
        batches = []
        tokenizer_output = tokenizer(word)
        ids = tokenizer_output.input_ids
        attn = tokenizer_output.attention_mask
        start_idx = 0

        # sliding windows with 50% overlap
        # start_idx is for correctly indexing the "later 50%" of sliding windows
        while len(ids) > ctx_size:
            # for GPT-NeoX (bos_id not appended by default)
            if "gpt-neox" in model_variant:
                batches.append((transformers.BatchEncoding({"input_ids": torch.tensor([bos_id] + ids[:ctx_size-1]).unsqueeze(0),
                                                               "attention_mask": torch.tensor([1] + attn[:ctx_size-1]).unsqueeze(0)}),
                                    start_idx))
            # for GPT-2/GPT-Neo (bos_id not appended by default)
            elif "gpt" in model_variant:
                batches.append((transformers.BatchEncoding({"input_ids": torch.tensor([bos_id] + ids[:ctx_size-1]),
                                                                "attention_mask": torch.tensor([1] + attn[:ctx_size-1])}),
                                    start_idx))
            # for OPT (bos_id appended by default)
            else:
                batches.append((transformers.BatchEncoding({"input_ids": torch.tensor(ids[:ctx_size]).unsqueeze(0),
                                                            "attention_mask": torch.tensor(attn[:ctx_size]).unsqueeze(0)}),
                                    start_idx))

            ids = ids[int(ctx_size/2):]
            attn = attn[int(ctx_size/2):]
            start_idx = int(ctx_size/2)-1

        # remaining tokens
        if "gpt-neox" in model_variant:
            batches.append((transformers.BatchEncoding({"input_ids": torch.tensor([bos_id] + ids).unsqueeze(0),
                                                           "attention_mask": torch.tensor([1] + attn).unsqueeze(0)}),
                               start_idx))
        elif "gpt" in model_variant:
                batches.append((transformers.BatchEncoding({"input_ids": torch.tensor([bos_id] + ids),
                                                           "attention_mask": torch.tensor([1] + attn)}),
                               start_idx))
        else:
            batches.append((transformers.BatchEncoding({"input_ids": torch.tensor(ids).unsqueeze(0),
                                                            "attention_mask": torch.tensor(attn).unsqueeze(0)}),
                                start_idx))

        curr_word_ix = 0
        curr_word_surp = []
        curr_toks = ""
        words = [word]
        for batch in batches:
            batch_input, start_idx = batch
            output_ids = batch_input.input_ids.squeeze(0)[1:]

            with torch.no_grad():
                model_output = model(**batch_input)

            toks = tokenizer.convert_ids_to_tokens(batch_input.input_ids.squeeze(0))[1:]
            index = torch.arange(0, output_ids.shape[0])
            surp = -1 * torch.log2(softmax(model_output.logits).squeeze(0)[index, output_ids])

            for i in range(start_idx, len(toks)):
                # necessary for diacritics in Dundee
                cleaned_tok = toks[i].replace("Ġ", "", 1).encode("latin-1").decode("utf-8")

                # for token-level surprisal
                # print(cleaned_tok, surp[i].item())

                # for word-level surprisal
                curr_word_surp.append(surp[i].item())
                curr_toks += cleaned_tok
                # summing subword token surprisal ("rolling")
                words[curr_word_ix] = words[curr_word_ix].replace(cleaned_tok, "", 1)
                if words[curr_word_ix] == "":
                    surprisal_dict[curr_toks] = sum(curr_word_surp)
                    '''print(curr_toks, sum(curr_word_surp))
                    curr_word_surp = []
                    curr_toks = ""
                    curr_word_ix += 1'''




if __name__ == "__main__":
    main()