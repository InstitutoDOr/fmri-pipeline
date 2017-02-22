function criaMask()

import idor.imgs.*
atlas = atlases.harvard_oxford; % brodmann | aal | harvard_oxford
areas = [11]; %Incluir numeros das areas que você quer na mascara

mask = Mascara( atlas );
mask.addAreas( areas );
%mask.exportImg( 'mask_acumbaoL.nii' );
%Para visualizar a mascara, descomentar a linha abaixo
mask.visualizar();