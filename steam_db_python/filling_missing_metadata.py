import pandas as pd
import requests
import time
from tqdm import tqdm

df = pd.read_csv('steam_library_enriched_cleaned.csv')

def fetch_metadata(appid):
    url = f"https://store.steampowered.com/api/appdetails?appids={appid}"
    try:
        res = requests.get(url, timeout=10)
        data = res.json().get(str(appid), {})
        if not data.get("success", False):
            return None
        
        info = data["data"]
        return {
            "release_date": info.get("release_date", {}).get("date"),
            "developer": ", ".join(info.get("developers", [])),
            "publisher": ", ".join(info.get("publishers", [])),
            "genres": ", ".join([g["description"] for g in info.get("genres", [])]),
            "price": info.get("price_overview", {}).get("final_formatted"),
        }
    except Exception:
        return None
    
missing_mask = (
    df['release_date'].isna()
    | df["developer"].isna()
    | df["publisher"].isna()
    | df["genres"].isna()
    | df["price"].isna()
)
df_missing = df[missing_mask]
print(f"Found {len(df_missing)} games missing metadata.")

for idx, row in tqdm(df_missing.iterrows(), total=len(df_missing)):
    appid = row['appid']
    meta = fetch_metadata(appid)
    if meta:
        for key, value in meta.items():
            if pd.isna(df.at[idx, key]) or df.at[idx, key] == '':
                df.at[idx, key] = value
    time.sleep(0.3)

output_file = 'steam_library_enriched_filled.csv'
df.to_csv(output_file, index=False)

print(f"✅ Done! Updated file saved as: {output_file}")