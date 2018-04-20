% Filename: MaterialsScript
% Radiator and MLI Materials Options for Trade Study
% Space 582 - Orbital ATK SMART RSD, Thermal Control Subsystem

%% Radiator Options

e_rad = 0.8;  %8 mil quartz mirror
a_rad = 0.05+.12;

%% MLI Materials

% Outer Cover Materials
a_MLI_outer = [0.45; %Beta cloth
               0.37; %aluminized beta cloth
               0.3;  %Reinforced tedlar
               0.41; %kapton, 0.0013 cm
               0.44; %kapton, 0.025 cm
               0.49; %kapton, 0.0051 cm
               0.51; %kapton, 0.0076 cm
               0.54; %kapton, 0.0127 cm
               0.1;  %backed teflon, 0.0013 cm
               0.1;  %backed teflon, 0.025 cm
               0.1;  %backed teflon, 0.0051 cm
               0.1;  %backed teflon, 0.0127 cm
               0.1;  %backed teflon, 0.0191 cm
               0.1;  %backed teflon, 0.0254 cm         
               0.14; %coated and backed teflon, 0.0051 cm
               0.14];%coated and backed teflon, 0.0127 cm

e_MLI_outer = [0.8;  %Beta cloth
               0.3;  %aluminized beta cloth
               0.8;  %Reinforced tedlar
               0.5;  %kapton, 0.0013 cm
               0.62; %kapton, 0.025 cm
               0.71; %kapton, 0.0051 cm
               0.77; %kapton, 0.0076 cm
               0.81; %kapton, 0.0127 cm
               0.4;  %backed teflon, 0.0013 cm
               0.48; %backed teflon, 0.025 cm
               0.6;  %backed teflon, 0.0051 cm
               0.75; %backed teflon, 0.0127 cm
               0.8;  %backed teflon, 0.0191 cm
               0.85; %backed teflon, 0.0254 cm         
               0.6;  %coated and backed teflon, 0.0051 cm
               0.75];%coated and backed teflon, 0.0127 cm   

% Interior-Layer Materials

a_MLI_interior_nc_side = [0.31; %non-coated kapton side, 0.00076 mm
                          0.31; %non-coated kapton side, 0.00013 mm
                          0.33; %non-coated kapton side, 0.0025 mm
                          0.34; %non-coated kapton side, 0.0051 mm
                          0.27; %non-coated kapton side, 0.0076 mm
                          0.41; %non-coated kapton side, 0.0127 mm
                          0.16; %non-coated aluminized side, 0.00076 mm
                          0.16; %non-coated aluminized side, 0.00013 mm
                          0.19; %non-coated aluminized side, 0.0025 mm
                          0.23; %non-coated aluminized side, 0.0051 mm
                          0.25; %non-coated aluminized side, 0.0076 mm
                          0.27]; %non-coated aluminized side, 0.0127 mm
                          
a_MLI_interior = [0.14; %aluminized kapton
                  a_MLI_interior_nc_side(1:6); %single aluminized kapton
                  0.30; %double goldized kapton
                  a_MLI_interior_nc_side(1:6); %single goldized kapton
                  0.14; %double aluminized mylar
                  a_MLI_interior_nc_side(7:12); %single aluminized mylar
                  0.14; %polyester
                  0.14];%teflon
              
          
                  
e_MLI_interior_nc_side = [0.50; %non-coated kapton side, 0.00076 mm
                          0.55; %non-coated kapton side, 0.00013 mm
                          0.65; %non-coated kapton side, 0.0025 mm
                          0.75; %non-coated kapton side, 0.0051 mm
                          0.81; %non-coated kapton side, 0.0076 mm
                          0.86; %non-coated kapton side, 0.0127 mm
                          0.33; %non-coated aluminized side, 0.00076 mm
                          0.46; %non-coated aluminized side, 0.00013 mm
                          0.57; %non-coated aluminized side, 0.0025 mm
                          0.72; %non-coated aluminized side, 0.0051 mm
                          0.77; %non-coated aluminized side, 0.0076 mm
                          0.81];%non-coated aluminized side, 0.0127 mm 
                          
e_MLI_interior = [0.03; %double aluminized kapton, 1
                  e_MLI_interior_nc_side(1:6); %single aluminized kapton, 2-7
                  0.02; %double goldized kapton, 8
                  e_MLI_interior_nc_side(1:6); %single goldized kapton, 9-14
                  0.03; %double aluminized mylar, 15
                  e_MLI_interior_nc_side(7:12); %single aluminized mylar, 16-21                 
                  0.04; %polyester, 22
                  0.04];%teflon, 23
        
              
% Inner Cover Materials
e_MLI_inner = [e_MLI_layered(0.06,.4,1); %polymide
               e_MLI_layered(0.04,.2,1);  %double goldized polymide
               0.04]; %glass reinforced aluminized polymide

% MLI Blanket Emissivity
layers = 10:5:25;
e_MLI = zeros(length(e_MLI_outer),length(e_MLI_interior),length(e_MLI_inner),length(layers));
for i = 1:length(layers)
    for k = 1:length(e_MLI_interior)
        
        if any(k == [1,8,15,22,23])
            e_MLI_il = e_MLI_layered(e_MLI_interior(k),e_MLI_interior(k),layers(i));
        else
            if any(k == [2:7])
                e_MLI_il = e_MLI_layered(e_MLI_interior(k),e_MLI_interior(1),layers(i));
            elseif any(k == [9:14])
                e_MLI_il = e_MLI_layered(e_MLI_interior(k),e_MLI_interior(8),layers(i));
            elseif any(k == [16:21])
                e_MLI_il = e_MLI_layered(e_MLI_interior(k),e_MLI_interior(15),layers(i));  
            end
        end            
        
        for j = 1:length(e_MLI_outer)
            for l = 1:length(e_MLI_inner)
                
                e_MLI(j,k,l,i) = e_eff(e_MLI_outer(j),e_MLI_il,e_MLI_inner(l));
                
            end
        end
    end
end
        
% MLI Blanket Absorptivity        
a_MLI = zeros(size(e_MLI));
for j = 1:length(e_MLI_outer)
    a_MLI(j,:,:,:) = a_eff( a_MLI_outer(j),e_MLI_outer(j),e_MLI(j,:,:,:) );
end

