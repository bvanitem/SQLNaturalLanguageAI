import os
from openai import OpenAI

# Get the API key from the environment variables
api_key = os.getenv("TOKEN")  

if not api_key:
    raise ValueError("Missing API key. Make sure 'TOKEN' is set as an environment variable.")

client = OpenAI(api_key=api_key)

completion = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[
        {"role": "user", "content": "write a haiku about AI"}
    ]
)

print(completion.choices[0].message.content)