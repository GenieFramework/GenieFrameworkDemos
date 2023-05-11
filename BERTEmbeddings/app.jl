module App
using Transformers
using Transformers.TextEncoders
using Transformers.HuggingFace
using TextEncodeBase, LinearAlgebra
using GenieFramework
using PlotlyBase
using StatsBase
using MultivariateStats
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

function get_embeddings_and_tokens(text)
    textencoder, bert_model = hgf"bert-base-uncased"
    sample = encode(textencoder, text) # tokenize + pre-process (add special tokens + truncate / padding + one-hot encode)
    bert_features = bert_model(sample).hidden_state[:, 2:end-1]
    tokens = [string(string(i) * "." * t.x) for (i, t) in enumerate(TextEncodeBase.tokenize(textencoder, text))]
    return bert_features, tokens
end

function get_similarity_matrix(bert_features, tokens)
    function cosine_similarity(a, b)
        dot(a, b) / (norm(a) * norm(b))
    end
    n_words = length(tokens)
    similarity_matrix = zeros(n_words, n_words)
    for i in 1:n_words
        for j in 1:n_words
            similarity_matrix[i, j] = cosine_similarity(bert_features[:, i], bert_features[:, j])
        end
    end
    vec_matrix = [similarity_matrix[:, i] for i in 1:n_words]
    return vec_matrix
end


function get_pca_embeddings(bert_features; n_dimensions=2)
    # mean centering the data
    M = mean(bert_features, dims=2)
    X_centered = bert_features .- M
    # calculate PCA
    pca = fit(PCA, X_centered; maxoutdim=n_dimensions)
    # project onto the principal components
    pca_embeddings = transform(pca, X_centered)
    return pca_embeddings'
end

@app begin 
    @out hmap_data = [heatmap()]
    @out scatter_data = [scatter()]
    @out hmap_layout = PlotlyBase.Layout(title="Semantic relationship heatmap", height=500,width=500, margin=attr(l=1, r=1, t=40, b=1))
    @out scatter_layout = PlotlyBase.Layout(title="2D PCA embeddings", height=500,width=500, margin=attr(l=1, r=1, t=40, b=1))
    @in text = "The bank robber stole from the bank vault and went to the river bank"
    @in process = false
    @out processing = false
    @onchange process begin
        processing = true
        bert_features, tokens = get_embeddings_and_tokens(text)
        similarity_matrix = get_similarity_matrix(bert_features, tokens)
        hmap_data = [heatmap(
                             z = similarity_matrix,
                             x = tokens,
                             y = tokens,
                            )]
        embeddings = get_pca_embeddings(bert_features, n_dimensions=2)
        scatter_data = [scatter(
                                x=embeddings[:,1],
                                y=embeddings[:,2],
                                mode="markers+text",
                                textposition="top center",
                                text=tokens
                               )]
        processing = false
    end
end

@page("/", "app.jl.html")
Server.up()
end
