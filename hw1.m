
%---------------------------------PART 1--------------------------------
%Generate N observations from a normal distribution
N = 10;
data = randn(N,1);

%The mean and variance of the data
m = mean(data);
v = var(data);

%Setup the mean and variance
%user_m : user-specified mean, user_v is the user-specified variance
user_m =input('set the mean :');
user_v =input('set the variance :');
user_N =input('set the number of sampling data N :');
data_u = user_m + sqrt(user_v).*randn(N,1);
m_u = mean(data_u);
m_v = var(data_u);

%---------------------------------PART 2--------------------------------
%) Theoretically derive:
% mean(N_1|N_2) = ((N_1*u_1)+(N_2*u_2))/(N_1+N_2)
%               = (2000*1+1000*4)/(2000+1000)
%               = 2
% variance(N_1|N_2) = 
%
%
%
%
%
%
