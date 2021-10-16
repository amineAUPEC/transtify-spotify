# transtify-spotify
REST API with bash and tokenless
deezer to spotify 
or csv to spotify 
spotify importer from csv


Soon will do to export to csv or json a playlist of spotify


readme will be updated soon



# files  
**demo.csv** : contains your favorites tracks or searching list this is the main input file  
**token.txt**: contains your token from Spotify you can generate temporary token   
>              *to get it* https://developer.spotify.com/console/get-album-tracks/ -> get token ...  
**uid.txt**: contains yout spotify userid   
>              *to get it* https://developer.spotify.com/console/get-current-user/  
**importer_csv_to_spotify.sh** : this script without CLI arg will use these files and generate a new playlist called as "Generated"  




## format of demo.csv   
track_title;artist  
track_title  
typeofmusic;artist  
playlist;track_title  
track_title;artist  
