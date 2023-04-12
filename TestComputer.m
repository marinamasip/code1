classdef TestComputer < handle
    
    properties(Access=private)
        KG
        Fel
        u
        type
        problemParameters
    end
    
    methods (Access=public)
        function obj=TestComputer(cParams)
            obj.init(cParams)
        end
        
        function compute(obj)
           obj.computeProblemResults();
           obj.computeTest(); 
        end
    end
    
    methods (Access=private)
        function init(obj,cParams)
            obj.problemParameters = cParams.problemParameters;
            obj.type              = cParams.type;
        end
        
        function computeProblemResults(obj) 
            a=StructureSolver(obj.problemParameters);
            a.compute();
            obj.KG=a.KG;
            obj.Fel=a.Fel;
            obj.u=a.u;
        end
        
        function computeTest(obj)
            load('test.mat');
            delta=10^-5;
            if(abs(obj.KG-KGref)<delta)
                disp 'Test passed. The stiffness matrix has been assembled properly';
            else
                disp 'Test failed';
            end
            load('testForce.mat')
            if(abs(obj.Fel-FelTest)<delta)
                disp 'Test passed. Total force coincides with the expected value ';
            else
                disp 'Test failed';
            end
            load('uTestIterative.mat')
            load('uTestDirect.mat')
            switch obj.type
                case 'Direct'
                if(abs(obj.u-uIterative)<delta)
                    disp 'Test passed. The displacements vector have the expected value both using Direct and Iterative solver.';
                else
                    disp 'Test failed';
                end
                case'Iterative'
                if(abs(obj.u-uDirect)<delta)
                    disp 'Test passed. The displacements vector have the expected value both using Direct and Iterative solver.';
                else
                    disp 'Test failed';
                end
            end 
        end
    end
end