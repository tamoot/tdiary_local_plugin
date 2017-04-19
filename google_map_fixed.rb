@@gmap_fixed_params = {
   :width => 600, 
   :height => 300, 
   :zoom => 10, 
   :overview => true,
   :title => 'here'
}

def google_map_fixed(lat, lon, params = {})
   modified_params = @@gmap_fixed_params.dup.merge(params)
   google_map(lat, lon, modified_params)
end

def google_geomap_fixed(address, params = {})
   modified_params = @@gmap_fixed_params.dup.merge(params)
   google_geomap(address, modified_params)
end

