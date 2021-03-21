#!/bin/bash
# links

# https://developer.spotify.com/console/get-search-item/?q=&type=&market=&limit=&offset=&include_external=



#to be defined : token ; uid ; file_input_csv "track_name,artist,album"
token=$(cat token.txt) # token input it into a file
uid=$(cat uid.txt) #spotify user id #define it
#be sure to input a csv file into LF (change it IN VSCODE or online)
# https://app.execeratics.com/LFandCRLFonline/?l=en
musics_file_deezer=$(cat all_deezer_exported_OR_list_csv.csv)



content_playable="is_playable"



# deleting files 
rm -rf demo2_transtify_json.json 
rm -rf demo2_transtify_json_grep1.json
rm -rf demo2_transtify_json_grep3.json
rm -rf demo2_transtify_json_grep3_all.json
# rm -rf demo2_transtify_json_grep4.json
rm -rf demo2_generated_playlist.json
rm -rf demo2_failed.txt
rm -rf demo2_success.txt
# rm -rf demo2_output.logsh


# generating playlist
curl -X "POST" "https://api.spotify.com/v1/users/$uid/playlists" --data "{\"name\":\"Generated\",\"description\":\"Generated_Playlist  description \",\"public\":true}" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $token" > demo2_generated_playlist.json
if [ $? -eq 0 ]
    then
        echo "success generated playlist"

fi


cat demo2_generated_playlist.json | jq .id | sed 's/"//g'  > demo2_generated_playlist.json
echo "playlist id to add track is : "
cat demo2_generated_playlist.json



for musics in $musics_file_deezer
do
    curl -X "GET" "https://api.spotify.com/v1/search?q=$musics&type=track&market=FR&limit=10&offset=0" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $token" > demo2_transtify_json.json
    curl -X "GET" "https://api.spotify.com/v1/search?q=$musics&type=track&market=FR&limit=10&offset=0" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $token" 

    cat demo2_transtify_json.json | grep -B 6 -A 15 $content_playable > demo2_transtify_json_grep1.json #without artist id
    cat demo2_transtify_json_grep1.json | grep "uri" | head -n 1 >> demo2_transtify_json_grep3_all.json
# creating file to store URI spotify track
    echo "{ "> demo2_transtify_json_grep3.json
    cat demo2_transtify_json_grep1.json | grep "uri" | head -n 1 >> demo2_transtify_json_grep3.json
    echo "} ">> demo2_transtify_json_grep3.json
# parsing avec jq
    cat demo2_transtify_json_grep3.json | jq .uri | sed 's/"//g' > demo2_transtify_json_grep3.json 
    echo "searched track : "
    cat demo2_transtify_json_grep3.json

    

            # adding track to playlist
            var_track_id=$(cat demo2_transtify_json_grep3.json)
            var_playlist_id=$(cat demo2_generated_playlist.json)

                if [ $var_track_id != "null" ]
                then
                    echo "SUCCESS : @searchme $musics $var_track_id" >> demo2_success.txt
                else 
                    echo "FAILED : @searchme $musics "
                    echo "FAILED : @searchme $musics " >> demo2_failed.txt
                fi
    

            for tracks in $var_track_id
            do
                curl -X "POST" "https://api.spotify.com/v1/playlists/$var_playlist_id/tracks?uris=$tracks" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $token"  
                    if [ $? -eq 0 ]
                        then
                            echo -e "\n success added track $tracks to playlist"

                    fi
            done



done
