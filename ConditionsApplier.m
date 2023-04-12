classdef ConditionsApplier < handle
    properties (Access=private)
        nDOFsNode
        totalNumDOFs
    end
    
    properties (Access=public)
        vL
        vR
        uR
    end
    
    methods (Access=public)
        function obj=ConditionsApplier(cParams)
            obj.init(cParams);
        end
        
        function compute(obj)
            obj.applyCond();
        end
    end
    
    methods (Access=private)
        function init (obj,cParams)
            obj.nDOFsNode    = cParams.nDOFsNode;
            obj.totalNumDOFs = cParams.totalNumDOFs;
        end
        
        function applyCond(obj)
            fixNod = [1 1 0
                      1 2 0];
            obj.vL=zeros(obj.totalNumDOFs-size(fixNod,1),1);
            obj.vR=zeros(size(fixNod,1),1);
            obj.uR=zeros(size(fixNod,1),1);
            for i=1:size(fixNod,1)
                if fixNod(i,2)==1       
                    obj.vR(i)=fixNod(i,1)*obj.nDOFsNode-1;
                else
                    obj.vR(i)=fixNod(i,1)*obj.nDOFsNode;
                end
            end
            for i=1:size(fixNod,1)
                obj.uR(i,1)=fixNod(i,3);
            end
            e=1:obj.totalNumDOFs;
            e(obj.vR)=[];
            obj.vL=transpose(e);
        end
    end
end