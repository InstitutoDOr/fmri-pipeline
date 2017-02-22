classdef PRJ1206_SEP_EXE < handle & ProjectSPM & PRJ1206
    properties
        %Atributos específicos do projeto
    end
    
    methods (Access = public)
        function obj=PRJ1206_SEP_EXE()
            
            obj.numSessions = 1; %Quantidade de RUNs

            obj.baseDir = 'C:\Documents and Settings\sebastian\Desktop\TEST_PROCESSAMENTO\fMRI\';
            obj.rawDir = 'C:\Documents and Settings\sebastian\Desktop\TEST_PROCESSAMENTO\fMRI\RAW_DATA';
            
            obj.pathSessions = {'fMRI_EXE'};
            
            %Output
            obj.folderFL = 'STATS_EXE';
            
            % Contrasts
            obj.contrastes = FirstLevel.importContrastsXls( '\\10.36.4.201\dados3\Users\sebastian\My Documents\MATLAB\processingSPM\docs\PRJ1206_EXE.xlsx' );

            obj.filter = 128;
            
        end
    end
    
    methods (Access = protected)
        
         function batch(obj, varargin)
                          
            obj.description = 'First Level Fixed';
            obj.midLevel = 1;
            obj.outDir = fullfile(obj.baseDir, obj.folderFLF, ['NORMAL_REST_EXE' sprintf( '_%i', obj.subjects )] );
            obj.processarFirstLevelFixed();
            
        end
                
        function ajustaConditions(obj)
                obj.conditions.sess(1).cond(1).name = 'EXE';
                obj.conditions.sess(1).cond(1).onset = 11:20:200;
                obj.conditions.sess(1).cond(1).duration = 10;
                obj.conditions.sess(1).cond(2).name = 'REPOUSO';
                obj.conditions.sess(1).cond(2).onset = 1:20:200;
                obj.conditions.sess(1).cond(2).duration = 10;
        end
    end
end