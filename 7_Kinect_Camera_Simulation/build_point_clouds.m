%% Build XYZ Point Clouds
% David Olson, 05 Aug 2021

% Doing this here instead of Simulink because Simulink is making everything
% as difficult as fucking possible!

%% Build Point Clouds

for k = 1 : P.t_end
    
    % Build Front Wall_____________________________________________________
    
    C = rotate_z(P.wall_psi(1,k)) * rotate_y(pi/2);
    front_xyz = gen_plane(C, ...
                          P.org(1:3,k), ...
                          P.front_wall.dim, ...
                          P.front_wall.dx, ...
                          P.front_wall.dy, ...
                          P.front_wall.sigmas);
    
    if (P.wall_psi(1,k) == 999)
        
        front_xyz(:,:) = 0;
        
    end
    
    % Build Side Wall______________________________________________________
    
    C = rotate_z(P.wall_psi(2,k)) * rotate_z(pi/2) * rotate_y(pi/2);
    side_xyz = gen_plane(C, ...
        P.org(4:6,k), ...
        P.side_wall.dim, ...
        P.side_wall.dx, ...
        P.side_wall.dy, ...
        P.side_wall.sigmas);
    
    if (P.wall_psi(2,k) == 999)
        
        side_xyz(:,:) = 0;
        
    end
    
    % Put Results Together_________________________________________________
    xyz = [front_xyz, side_xyz];
    P.xyz(:,:,k) = xyz;
    
end

%% Clear Unneeded Variables

clear C front_xyz side_xyz xyz k