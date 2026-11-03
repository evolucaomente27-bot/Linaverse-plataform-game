with open('scenes/player/player_frames.tres', 'r', encoding='utf-8') as f:
    orig = f.read()

with open('scenes/player/player_frames_celestial.tres', 'r', encoding='utf-8') as f:
    cel = f.read()

print('orig has loop: 1?', '"loop": 1' in orig)
print('cel has loop: 1?', '"loop": 1' in cel)
print('orig has loop: true?', '"loop": true' in orig)
print('cel has loop: true?', '"loop": true' in cel)
