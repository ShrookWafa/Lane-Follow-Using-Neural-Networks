% Lane Follow application using Neural Networks with regularization
% Data X is flattened pictures of different states of the road
% Labels Y classifies whether the car should go left "1", right "2", or
% straight "3"

% Loading data and setting matrices for training and testing
load('filename.mat');
load('filename2.mat');
load('filename3.mat');
X_train = [X; X2];
X_train = X_train';
Y_train = [Y; Y2];
y1 = Y_train' == 1;
y2 = Y_train' == 2;
y3 = Y_train' == 3;
Y_train = [y1; y2; y3];
X_test = X3';
yt1 = Y3' == 1;
yt2 = Y3' == 2;
yt3 = Y3' == 3;
Y_test = [yt1; yt2; yt3];

% Normalization
X_train = X_train./255;
X_test = X_test./255;

% Initializing the needed variables
S = size(X_train);
learning_rate = 0.03;
num_iterations = 1500;
lambda = 0.03; % regularization coefficient
m = S(2); % number of examples
n_x = S(1); % input layer size
n_h = 50; % one hidden layer with 50 hidden units
n_y = 3; % 3 labels

% Initializing Neural Network parameters
W1 = randn(n_h, n_x)*sqrt(2/S(1));
b1 = zeros(n_h, 1);
W2 = randn(n_y, n_h)*sqrt(2/S(1));
b2 = zeros(n_y, 1);

% The training
for i=1:num_iterations,
    
    % Forward Propagation
    Z1 = W1*X_train + repmat(b1, [1 S(2)]);
    A1 = tanh(Z1);
    Z2 = W2*A1 + repmat(b2, [1 S(2)]);
    A2 = tanh(Z2);

    % Print out cost to check the progress
    cost = (-1/m) * sum(sum(Y_train.*log(A2)+(1-Y_train).*log(1-A2)));
    cost = cost + lambda/(2*m)*(sum(sum(W1*W1'))+sum(sum(W2*W2'))); % adding regularization term
    if mod(i,100)==0,
        fprintf('%d\n',cost);
    end

    % Backward Propagation 
    dZ2 = A2 - Y_train;
    dW2 = (1/m) .* dZ2*A1' + lambda/m*W2;
    db2 = (1/m) * sum(dZ2,2);
    dZ1 = (W2'*dZ2) .* (1 - power(A1, 2));
    dW1 = (1/m) .* dZ1*X_train' + lambda/m*W1;
    db1 = (1/m) .* sum(dZ1,2);

    % Updating parameters
    W1 = W1 - learning_rate.*dW1;
    b1 = b1 - learning_rate.*db1;
    W2 = W2 - learning_rate.*dW2;
    b2 = b2 - learning_rate.*db2;

end

% Checking the accuracy of the network on training data
[M, I] = max(A2);
Yy = [Y; Y2];
temp = I==Yy';
train_accuracy = mean(temp)*100;
fprintf('train accuracy = %f\n',train_accuracy);

% Checking the accuracy of the network on test data
S2 = size(X_test);
Z1 = W1*X_test + repmat(b1, [1 S2(2)]);
A1 = tanh(Z1);
Z2 = W2*A1 + repmat(b2, [1 S2(2)]);
A2 = tanh(Z2);
[M, I] = max(A2);
temp = I==Y3';
test_accuracy = mean(temp)*100;
fprintf('test accuracy = %f\n',test_accuracy);
