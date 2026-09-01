import re

def process_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find all objects
    # format: { slug: "chest", path: { left: ["..."], right: ["..."] } } or just path: ["..."]
    parts = {}
    
    # We will just use regex to find slug and then find left/right paths
    slugs = re.findall(r'slug:\s*"([^"]+)"', content)
    
    for slug in slugs:
        # Find the block for this slug
        block_match = re.search(r'slug:\s*"' + slug + r'".*?path:\s*{(.*?)}', content, re.DOTALL)
        if block_match:
            path_block = block_match.group(1)
            left_paths = re.findall(r'left:\s*\[(.*?)\]', path_block, re.DOTALL)
            right_paths = re.findall(r'right:\s*\[(.*?)\]', path_block, re.DOTALL)
            
            left_strs = []
            if left_paths:
                left_strs = re.findall(r'"([^"]+)"', left_paths[0])
                
            right_strs = []
            if right_paths:
                right_strs = re.findall(r'"([^"]+)"', right_paths[0])
                
            parts[slug] = {'left': left_strs, 'right': right_strs}
        else:
            # Maybe path is just an array?
            block_match = re.search(r'slug:\s*"' + slug + r'".*?path:\s*\[(.*?)\]', content, re.DOTALL)
            if block_match:
                path_block = block_match.group(1)
                paths = re.findall(r'"([^"]+)"', path_block)
                parts[slug] = {'center': paths}
                
    return parts

front = process_file(r"k:\gymbuddy\bodyFront.ts")
back = process_file(r"k:\gymbuddy\bodyBack.ts")

dart_file = """
class AnatomyPaths {
  static const Map<String, List<String>> front = {
"""

for slug, sides in front.items():
    paths = []
    if 'left' in sides: paths.extend(sides['left'])
    if 'right' in sides: paths.extend(sides['right'])
    if 'center' in sides: paths.extend(sides['center'])
    
    paths_str = ", ".join([f'"{p}"' for p in paths])
    dart_file += f'    "{slug}": [{paths_str}],\n'

dart_file += """  };

  static const Map<String, List<String>> back = {
"""

for slug, sides in back.items():
    paths = []
    if 'left' in sides: paths.extend(sides['left'])
    if 'right' in sides: paths.extend(sides['right'])
    if 'center' in sides: paths.extend(sides['center'])
    
    paths_str = ", ".join([f'"{p}"' for p in paths])
    dart_file += f'    "{slug}": [{paths_str}],\n'

dart_file += """  };
}
"""

with open(r"k:\gymbuddy\lib\features\statistics\widgets\anatomy_paths.dart", "w") as f:
    f.write(dart_file)

print("Dart file created successfully!")
