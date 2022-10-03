classdef IterativeSolver < Solver
    
    methods 
        function obj= IterativeSolver(cParam)
            obj.init(cParam);
        end
        
        function uL = solve(obj)
            uL=pcg(obj.LHS,obj.RHS);
        end
    end
end

            
           
    
