classdef StructureSolver < handle
    properties (Access=private)
        mYoung
        t1
        t2
        h1
        h2
        b
        gravity
        length1
        length2
        totalLength
        elementFlex
        totalFlex
        type
        nElements
        nElExactSol
    end
    
    properties (Access=public)
        KG
        Fel
        u
    end
    
    methods (Access=public)
        function obj=StructureSolver(cParams)
            obj.init(cParams);
        end
        
        function compute(obj)
            obj.calculateStructure();
        end
    end
    
    methods (Access=private,Static)
        function [n_d,n_nod,n_ne,n_i,n_dof]=defineDimensions(x)
            n_d = size(x,2);           
            n_nod = size(x,1);         
            n_ne = 2;                  
            n_i = 2;                   
            n_dof = n_i*n_nod;       
        end   
    end
    
    methods (Access=private)
        function init(obj,cParams)
            obj.mYoung      = cParams.mYoung;
            obj.t1          = cParams.t1;
            obj.t2          = cParams.t2;
            obj.h1          = cParams.h1;
            obj.h2          = cParams.h2;
            obj.b           = cParams.b;
            obj.gravity     = cParams.gravity;
            obj.length1     = cParams.length1;
            obj.length2     = cParams.length2;
            obj.totalLength = cParams.totalLength;
            obj.elementFlex = cParams.elementFlex;
            obj.totalFlex   = cParams.totalFlex;
            obj.type        = cParams.type;
            obj.nElements   = cParams.nElements;
            obj.nElExactSol = cParams.nElExactSol;           
        end
        
        function A=computeArea(obj)
            A = obj.b*((obj.h1+obj.h2)/2)-(obj.b-2*obj.t2)*((obj.h1+obj.h2-4*obj.t1)/2);
        end
        
        function C=computeCentroid(obj)
            C = ((obj.t2*obj.h1*(obj.b/2)+obj.t2*obj.h2*(-obj.b/2))/(obj.t2*(obj.h1+obj.h2)+2*obj.t1*(obj.b/cos(atan((obj.h1-obj.h2)/2*obj.b)))));
        end
        
        function Iz=computeInertia(obj)
            Izz1 = (1/12)*obj.t2*obj.h1^3 ;
            Izz2 = (1/12)*obj.t1*(obj.b/(cos(atan((obj.h1-obj.h2)/2*obj.b))))^3*(sin(atan(((obj.h1-obj.h2)/2)/obj.b)))^2+(((obj.h1/2)-(obj.h1-obj.h2)/4)^2*(obj.t1*(obj.b/(cos(atan((obj.h1-obj.h2)/2*obj.b))))));
            Izz3 = (1/12)*obj.t1*(obj.b/(cos(atan((obj.h1-obj.h2)/2*obj.b))))^3*(sin(atan(((obj.h1-obj.h2)/2)/obj.b)))^2+(((obj.h1/2)-(obj.h1-obj.h2)/4)^2*(obj.t1*(obj.b/(cos(atan((obj.h1-obj.h2)/2*obj.b))))));
            Izz4 = (1/12)*obj.t2*obj.h2^3 ;
            Iz = Izz1 + Izz2 + Izz3 + Izz4;
        end
        
        function x=computeNodalCoordinates(obj,k)
            delta = obj.totalLength/obj.nElements(k);
            x(1,1) = 0;
            for i = 2:(obj.nElements(k)+1)   
                x(i,1) = (i-1)*delta;
            end
        end
        
        function Tn=computeNodalConnectivities(obj,k,n_ne)
            Tn = size(obj.nElements(k),n_ne);
            for i = 1 : obj.nElements(k)
                Tn(i,1) = (2*i)-i;
                Tn(i,2) = (2*i)-i+1;
            end
        end
        
        function mat=assemblyMaterialPropertiesMatrix(obj,A,Iz)
             mat = [ obj.mYoung,A,Iz; 
                   ];
        end
        
        function Tmat=computeMaterialConnectivities(obj,k)
            Tmat=zeros;
            for i = 1 : obj.nElements(k)
                Tmat(i,1) = 1;
            end
        end
        
        function calculateStructure(obj)
            
            A = obj.computeArea();
            Iz = obj.computeInertia();

            s.length1=obj.length1;
            s.length2=obj.length2;
            s.totalFlex=obj.totalFlex;
            s.elementFlex=obj.elementFlex;
            s.gravity=obj.gravity;
            a=LiftComputer(s);
            a.compute();
            [l]=a.l;

            fig = plotBeamsInitialize(obj.length1+obj.length2);

            for k = 1:length(obj.nElements)
                x = obj.computeNodalCoordinates(k);
                [~,n_nod,n_ne,n_i,n_dof] = obj.defineDimensions(x);
                Tn = obj.computeNodalConnectivities(k,n_ne);
                mat = obj.assemblyMaterialPropertiesMatrix(A,Iz);
                Tmat = obj.computeMaterialConnectivities(k);

                s.nElements=obj.nElements(k);
                s.nNodes=n_nod;
                a=DOFsConnectivitesComputer(s);
                a.compute();
                Td=a.Td;
    
                s.nNodesBeam=n_ne;
                s.nElements=obj.nElements(k);
                s.nDOFsNode=n_i;
                s.coordinates=x;
                s.globNodalNum=Tn;
                s.matProp=mat;
                s.rowMat=Tmat;
                a=ElementStiffnessMatricesComputer(s);
                a.compute();
                Kel=a.Kel;
    
                s.length1=obj.length1;
                s.length2=obj.length2;
                s.totalFlex=obj.totalFlex;
                s.globNodalNum=Tn;
                s.coordinates=x;
                s.gravity=obj.gravity;
                s.lift=l;
                s.nElements=obj.nElements(k);
                a=LoadComputer(s);
                a.compute();
                q=a.q;
    
                s.q=q;
                s.nNodesBeam=n_ne;
                s.nElements=obj.nElements(k);
                s.nDOFsNode=n_i;
                s.coordinates=x;
                s.globNodalNum=Tn;
                a=ElementForceVectorComputer(s);
                a.compute();
                obj.Fel=a.Fel;
    
                s.nNodesBeam=n_ne;
                s.totalNumDOFs=n_dof;
                s.nElements=obj.nElements(k);
                s.nDOFsNode=n_i;
                s.Td=Td;
                s.Kel=Kel;
                s.Fel=obj.Fel;
                s.elementFlex=obj.elementFlex;
                s.gravity=obj.gravity;
                a=GlobalMatrixAssembler(s);
                a.compute();
                obj.KG=a.KG;
                Fext=a.Fext;
    
                s.nDOFsNode=n_i;
                s.totalNumDOFs=n_dof;
                a=ConditionsApplier(s);
                a.compute();
                vL=a.vL;
                vR=a.vR;
                uR=a.uR;
    
                s.vL=vL;
                s.vR=vR;
                s.uR=uR;
                s.KG=obj.KG;
                s.Fext=Fext;
                s.type=obj.type;
                a=SystemSolver(s);
                a.compute();
                obj.u=a.u;
                
    
                s.nElements=obj.nElements(k);
                s.u=obj.u;
                s.Td=Td;
                s.coordinates=x;
                s.globNodalNum=Tn;
                s.Kel=Kel;
                s.nNodesBeam=n_ne;
                s.nDOFsNode=n_i;
                a=InternalDistributionsComputer(s);
                a.compute();
                pu=a.pu;
                pt=a.pt;
                Fy=a.Fy;
                Mz=a.Mz;
    
                nsub = obj.nElExactSol/obj.nElements(k);
                plotBeams1D(fig,x,Tn,nsub,pu,pt,Fy,Mz)
                drawnow;
    
            end

            figure(fig)
            legend(strcat('N=',cellstr(string(obj.nElements))),'location','northeast');

        end
    end   
end