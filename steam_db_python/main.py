import requests
import pandas as pd
from tqdm import tqdm

api_key = #yourapi
steam_id = #steam_id

url = f"http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=""&steamid=""&include_appinfo=true&include_played_free_games=true"
response = requests.get(url)

data = response.json()

games = data['response']['games']

df = pd.json_normalize(games)

#convert from minutes to hours
df['playtime_hours'] = df['playtime_forever'] / 60

#adding columns
df = df[['appid', 'name', 'playtime_forever', 'playtime_hours']]

def get_game_metadata(appid):
    url = f"https://store.steampowered.com/api/appdetails?appids={appid}"
    try:
        res = requests.get(url, timeout=10)
        data = res.json().get(str(appid), {})
        if not data.get('success', False):
            return {}
        info = data['data']
        return {
            'release_date': info.get('release_date', {}).get('date'),
            'developer': ', '.join(info.get('developers', [])),
            'publisher': ', '.join(info.get('publishers', [])),
            'genres': ', '.join([g['description'] for g in info.get('genres', [])]),
            'price': info.get('price_overview', {}).get('final_formatted'),
        }
    except Exception:
        return {}

tqdm.pandas()

metadata = df['appid'].progress_apply(get_game_metadata)
meta_df = pd.DataFrame(metadata.tolist())

df_full = pd.concat([df, meta_df], axis=1)

df_full.to_csv('steam_library_enriched.csv', index=False)
