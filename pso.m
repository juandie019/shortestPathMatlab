%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA102
% Project Title: Implementation of Particle Swarm Optimization in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, Particle Swarm Optimization in MATLAB (URL: https://yarpiz.com/50/ypea102-particle-swarm-optimization), Yarpiz, 2015.
% ++696
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

clc;
clear;
close all;

%% Problem Definition

CostFunction = @(x, s, e) PathCost(x, s, e);        % Cost Function
GetUniqueList = @(x) UniqueList(x);     % Returns a list with no repited items 
PaintGraph = @(x) PaintGraph(x);        % Paints the graph and path
GetPenaltyValue = @() PenaltyValue();

nVar = 8;            % Number of Decision Variables

VarSize = [1 nVar];   % Size of Decision Variables Matrix

VarMin = 1;         % Lower Bound of Variables
VarMax = 8;         % Upper Bound of Variables

% Objetives
startNode = 1;
endNode = 8;

%% PSO Parameters

MaxIt = 100;      % Maximum Number of Iterations

nPop = 3000;        % Population Size (Swarm Size)

% PSO Parameters
w = 1;            % Inertia Weight
wdamp = 0.99;     % Inertia Weight Damping Ratio
c1 = 1.5;         % Personal Learning Coefficient
c2 = 2.0;         % Global Learning Coefficient

% Velocity Limits
VelMax = 0.1*(VarMax-VarMin);
VelMin = -VelMax;

%% Initialization

empty_particle.Position = [];
empty_particle.Cost = [];
empty_particle.Velocity = [];
empty_particle.Best.Position = [];
empty_particle.Best.Cost = [];

particle = repmat(empty_particle, nPop, 1);

GlobalBest.Cost = inf;

for i = 1:nPop
    
    % Initialize Position
    particle(i).Position = unifrnd(VarMin, VarMax, VarSize); 
    
    % Initialize Velocity
    particle(i).Velocity = zeros(VarSize);
    
    % Evaluation
    particle(i).Cost = CostFunction(particle(i).Position, startNode, endNode);

    % Update Personal Best
    particle(i).Best.Position = particle(i).Position;
    particle(i).Best.Cost = particle(i).Cost;
 
    % Update Global Best
    if  particle(i).Best.Cost<GlobalBest.Cost
        GlobalBest = particle(i).Best;
        
    end
    
end

BestCost = zeros(MaxIt, 1);

%% PSO Main Loop

for it = 1:MaxIt
    
    for i = 1:nPop
        
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(GlobalBest.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity, VelMin);
        particle(i).Velocity = min(particle(i).Velocity, VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Velocity Mirror Effect
        IsOutside = (particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside) = -particle(i).Velocity(IsOutside);
        
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position, VarMin);
        particle(i).Position = min(particle(i).Position, VarMax);
        
        % Evaluation
        particle(i).Cost = CostFunction(particle(i).Position, startNode, endNode);
        
        % Update Personal Best
        if  particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position = particle(i).Position;
            particle(i).Best.Cost = particle(i).Cost;
            
            % Update Global Best
            if  particle(i).Best.Cost<GlobalBest.Cost
                
                GlobalBest = particle(i).Best;
                
            end
            
        end
        
    end
    
    BestCost(it) = GlobalBest.Cost;
    
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    w = w*wdamp;
    
end

BestSol = GlobalBest;

%results
if(BestSol.Cost == GetPenaltyValue())
    disp('No soulution founded, modify nPop and MaxIt or Objetives may be incorrect');
else
    PaintGraph(GetUniqueList(BestSol.Position));
end
