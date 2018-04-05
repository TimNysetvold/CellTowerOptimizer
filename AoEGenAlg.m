%This script performs an optimizing real-value genetic algorithm seeking to 
%maximize the amount of military spending during the first 15 minutes of an
%Age of Empires II game.

clc
clear

chromosome_size = 49; % If chromosome length changes must change mutation function with it
generation_size = 10;
M = 10; % Total Number of generations
current_gen = 1; %Will need to keep track of the generaation we are on for mutation to work properly


generation_chromos = zeros(generation_size,chromosome_size);
fitness = zeros(generation_size,1);

%populate first generation chromosomes and fitness values
%there are no external constraints, so the fitness value is simply the
%value of the objective function, 'military_spend'
for i=1:size(generation_chromos,1)
    chromosome = ChromosomeGenerator();
    generation_chromos(i,:) = chromosome;
    fitness(i) = AoEModel(chromosome);
end

%perform tournament selection for mother and father chromosomes
tournament_size = 3;

for j=1:2
    %randomly select chromosomes
    rand_chromo_nums = randperm(generation_size,tournament_size);

    tournament_chromos = zeros(tournament_size,chromosome_size);
    tournament_fitnesses = zeros(tournament_size,1);
    for i=1:tournament_size
        tournament_chromos(i,:) = generation_chromos(rand_chromo_nums(i),:);
        tournament_fitnesses(i) = fitness(rand_chromo_nums(i));
    end

    %determine champion chromosome
    highest_tournament_fitness = max(tournament_fitnesses);
    highest_fitness_chromos = [];

    for i=1:tournament_size
        if tournament_fitnesses(i)==highest_tournament_fitness
            highest_fitness_chromos=[highest_fitness_chromos,rand_chromo_nums(i)];
        end
    end

    if length(highest_fitness_chromos)==1
        if j==1
            mother_chromo = generation_chromos(highest_fitness_chromos(1),:);
        elseif j==2
            father_chromo = generation_chromos(highest_fitness_chromos(1),:);
        end
    elseif length(highest_fitness_chromos)>1
        if j==1
            mother_chromo = generation_chromos(highest_fitness_chromos(randperm(length(highest_fitness_chromos),1)),:);
        elseif j==2
            father_chromo = generation_chromos(highest_fitness_chromos(randperm(length(highest_fitness_chromos),1)),:);
        end
    end
end


% Crossover

cross_prob = .9; % We can change this, set high to test cross over
cross_rand = rand(1);
if cross_rand < cross_prob
    cross_point = ceil(chromosome_size*rand(1));
    child_1 = [mother_chromo(1:cross_point),father_chromo(cross_point+1:end)];
    child_2 = [father_chromo(1:cross_point),mother_chromo(cross_point+1:end)];
   
else
    child_1 = mother_chromo;
    child_2 = father_chromo;
end

% Mutation
mut_prob = .1; % We can change, set high to test
% child_1_save = child_1; % Used to compare changes
child_1 = mutation(child_1, chromosome_size, M, current_gen, mut_prob);
% child_comp = [child_1_save;child_1]; % Used to compare changes
child_2 = mutation(child_2, chromosome_size, M, current_gen, mut_prob);




