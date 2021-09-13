function r_e__e_S = Geo_Radius(L_b_hat, P)
%GEO_RADIUS Calculates r_e__e_S as seen in Paul D. Groves Text
% page 71, equation 2.137

RE = P.R0 / sqrt(1 - P.e^2*(sin(L_b_hat)^2));

r_e__e_S = RE * sqrt(cos(L_b_hat)^2 + ((1 - P.e^2)^2 * (sin(L_b_hat)^2)));

end

