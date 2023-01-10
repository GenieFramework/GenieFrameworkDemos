using RDatasets, DataFrames, Flux, Random
using MLDatasets: BostonHousing
using BSON: @save, @load
using Flux: @epochs

Random.seed!(1)
features = BostonHousing.features()
target = BostonHousing.targets()
N_train = 350
N_test = length(target) - N_train
train_idx = randperm(length(target))[1:N_train]
test_idx = setdiff(1:length(target), train_idx)
x_train = features[:,train_idx]
x_test = features[:,test_idx]
y_train = target[:,train_idx]
y_test = target[:,test_idx]

model = Chain(Dense(13,64,relu), Dense(64,32,relu), Dense(32,16,relu), Dense(16,1,relu))

loss(x, y) = Flux.Losses.mse(model(x), y)
loss(x_train,y_train)

data = [(x_train,y_train)]
parameters = Flux.params(model)

@epochs 3000 Flux.train!(loss, parameters, data, ADAM())
@show loss(x_train, y_train)
@show loss(x_test,y_test)
@save "bostonflux.bson" model x_test y_test
