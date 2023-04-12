classdef SystemSolver < handle
    properties (Access=private)
        vL
        vR
        uR
        KG
        Fext
        type
    end
    
    properties (Access=public)
        u
        R
    end
    
    methods (Access=public)
        function obj=SystemSolver(cParams)
            obj.init(cParams)
        end
        
        function compute(obj)
            obj.solveSys();
        end
    end
    
    methods (Access=private)
        function init(obj,cParams)
            obj.vL   = cParams.vL;
            obj.vR   = cParams.vR;
            obj.uR   = cParams.uR;
            obj.KG   = cParams.KG;
            obj.Fext = cParams.Fext;
            obj.type = cParams.type; 
        end
        
        function [K_LL,K_LR,K_RL,K_RR]=assemblyK(obj)
            K_LL=obj.KG(obj.vL,obj.vL);
            K_LR=obj.KG(obj.vL,obj.vR);
            K_RL=obj.KG(obj.vR,obj.vL);
            K_RR=obj.KG(obj.vR,obj.vR);
        end
        
        function [Fext_R,P]=computeLoads(obj,K_LR)
            Fext_L=obj.Fext(obj.vL,1);
            Fext_R=obj.Fext(obj.vR,1);
            P=Fext_L-K_LR*obj.uR;
        end
    
        function solveSys(obj)
            [K_LL,K_LR,K_RL,K_RR]=obj.assemblyK();
            [Fext_R,P]=obj.computeLoads(K_LR);
            
            s.LHS = K_LL;
            s.RHS = P;
            s.type = obj.type;
            solver = Solver.create(s);
            uL=solver.solve();
            
            obj.R=K_RR*obj.uR+K_RL*uL-Fext_R;
            obj.u(obj.vL,1)=uL;
            obj.u(obj.vR,1)=obj.uR;
        end
    end
end