classdef IterativeSolver < Solver
    
    methods 
        function obj= IterativeSolver(cParam)
            obj.init(cParam);
        end
        
        function uL = solve(obj)
            uL=pcg(obj.LHS,obj.RHS,1e-6,1300);
        end
    end
end

            
           
    
