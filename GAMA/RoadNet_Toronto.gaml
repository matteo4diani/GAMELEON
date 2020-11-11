/**
* Name: NewModel
* Based on the internal empty template. 
* Author: simon
* Tags: 
*/

// Per caricare file GIS 
model load_shape_file 
 
global {
	 // Step temporale e numero di persone
    int nb_people <- 1;
    //int nb_infected_init <- 5;
    float step <- 5 #mn;
    
	// Questi file, strade e edifici sono stati preprocessati nel notebook "GIS_Data_Turin"
    file roads_shapefile <- file("C:/Users/simon/Desktop/MAS/Data/Traffic/Filtered_1st_neigh/2019-04-01-Toronto.shp");
    file buildings_shapefile <- file("C:/Users/simon/Desktop/MAS/Data/Toronto_final/Buildings_Toronto.shp");
    
    //Proviamo a caricare gli ospedali, saranno una tipologia diversa di buildings
    
    file hospitals_shapefile <- file("C:/Users/simon/Desktop/MAS/Data/Toronto_final/Hospitals_Toronto.shp");
   
    
    // Creaiamo il grafo stradale come base per il nostro modello
    geometry shape <- envelope(roads_shapefile);
    graph road_network;
    
    // Dinamica epidemica 
   /*int nb_people_infected <- nb_infected_init update: people count (each.is_infected);
    int nb_people_not_infected <- nb_people - nb_infected_init update: nb_people - nb_people_infected;
    float infected_rate update: nb_people_infected/nb_people;
    */
    
   

    init {
    // inizializzazione da file 
    create building from: buildings_shapefile;
    
    create road from: roads_shapefile;
    road_network <- as_edge_graph(road);
    
    create hospitals from: hospitals_shapefile;
    
    
    create people number:nb_people {
        location <- any_location_in(one_of(building));
        
        }
    /* ask nb_infected_init among people {
        is_infected <- true;
        }
        
    reflex end_simulation when: infected_rate = 1.0 {
        do pause;
    }   */
    }
}
// Edifici nella città di Torino

species building {
    string type; 
    rgb color <- #gray  ;
    
    aspect base {
    draw shape color: color ;
    }
}

// Strade di Torino 
species road {
    aspect geom {
    draw shape color: #black;
    }
}

species hospitals {
    string type; 
    rgb color <- #red  ;
    
    aspect base {
    draw shape color: color ;
    }
}

// Persone
species people {
    rgb color <- #yellow ;
    
    aspect base {
    draw circle(1) color: color border: #blue;
    }
}


// Costruzione interfaccia grafica
experiment main_experiment type:gui{
	parameter "Number of people agents" var: nb_people category: "People" ;

    output {
    display map {
    	species building aspect: base; 
    	species hospitals aspect: base;
        species road aspect:geom; 
        species people aspect: base;      
    }
    }
}

/* Insert your model definition here */

