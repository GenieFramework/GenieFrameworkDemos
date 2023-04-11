module App
using Transformers
using Transformers.TextEncoders
using Transformers.HuggingFace
using TextEncodeBase, LinearAlgebra
using GenieFramework
@genietools

function word_context_similarity(text)

    textencoder, bert_model = hgf"bert-base-uncased"

    function cosine_similarity(a, b)
        dot(a, b) / (norm(a) * norm(b))
    end

    sample = encode(textencoder, text) # tokenize + pre-process (add special tokens + truncate / padding + one-hot encode)

    bert_features = bert_model(sample).hidden_state[:,2:end-1]

    tokens = [string(string(i)*"."*t.x) for (i,t) in enumerate(TextEncodeBase.tokenize(textencoder, text))]
    n_words = length(tokens)
    similarity_matrix = zeros(n_words, n_words)

    for i in 1:n_words
        for j in 1:n_words
            similarity_matrix[i, j] = cosine_similarity(bert_features[:, i], bert_features[:, j])
        end
    end
    vec_matrix = [similarity_matrix[:,i] for i in 1:n_words]
    return tokens, vec_matrix
end

@handlers begin 
    @out hmap = PlotData()
    @out layout = PlotLayout()
    @in text = "The bank robber stole from the bank vault and went to the river bank"
    @in process = false
    @onchange isready, process begin
        tokens, similarity_matrix = word_context_similarity(text)
        @show tokens
        hmap = PlotData(
                      z = similarity_matrix,
                      x = tokens,
                      y = tokens,
                      plot = StipplePlotly.Charts.PLOT_TYPE_HEATMAP,
                     )
    end
end

@page("/", "ui.html")
Server.up()
end
