classdef DirectSolver < Solver
    
    methods
        function obj = DirectSolver(cParam)
           obj.init(cParam);
        end
        
        function uL = solve(obj)
            uL=obj.LHS\obj.RHS;   
        end
    end
end

    
        
            
        
           
            
            
