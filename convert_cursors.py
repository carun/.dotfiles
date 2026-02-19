#!/usr/bin/env python3
"""
Convert Windows cursor theme to Linux X11 cursor theme using xcursorgen
Download from https://vsthemes.org/en/dnew/47356.html
"""

import os
import struct
import subprocess
import sys
from pathlib import Path
from PIL import Image

class CursorConverter:
    def __init__(self, source_dir, output_dir):
        self.source_dir = Path(source_dir)
        self.output_dir = Path(output_dir)
        self.temp_dir = output_dir / 'temp'
        self.temp_dir.mkdir(parents=True, exist_ok=True)

    def read_cur_hotspot(self, filepath):
        """Read hotspot information from a Windows .cur file"""
        try:
            with open(filepath, 'rb') as f:
                # Read ICONDIR header
                reserved = struct.unpack('<H', f.read(2))[0]
                type_ = struct.unpack('<H', f.read(2))[0]
                count = struct.unpack('<H', f.read(2))[0]

                # Read ICONDIRENTRY for first image
                width = struct.unpack('<B', f.read(1))[0]
                height = struct.unpack('<B', f.read(1))[0]
                color_count = struct.unpack('<B', f.read(1))[0]
                reserved = struct.unpack('<B', f.read(1))[0]
                hotspot_x = struct.unpack('<H', f.read(2))[0]
                hotspot_y = struct.unpack('<H', f.read(2))[0]

                return hotspot_x, hotspot_y
        except Exception as e:
            print(f"Error reading hotspot from {filepath}: {e}")
            return 0, 0

    def extract_cur_to_png(self, cur_file, png_pattern):
        """Extract images from .cur file to PNG using ImageMagick
        Returns list of PNG files created"""
        try:
            # .cur files can contain multiple sizes, extract all with pattern
            subprocess.run(['convert', str(cur_file), str(png_pattern)], check=True, capture_output=True)

            # Find all created PNG files
            import glob
            # Replace %d with * to find all generated files
            base_pattern = str(png_pattern).replace('%d', '*')
            png_files = sorted(glob.glob(base_pattern))

            return png_files
        except subprocess.CalledProcessError as e:
            print(f"Error converting {cur_file}: {e}")
            return []

    def read_ani_file(self, filepath):
        """Read a Windows .ani file and extract frames and metadata"""
        frames_data = []
        delay = 60  # default delay in jiffies (1/60th of a second)

        try:
            with open(filepath, 'rb') as f:
                # Read RIFF header
                riff = f.read(4)
                if riff != b'RIFF':
                    print(f"Not a valid ANI file: {filepath}")
                    return frames_data, delay

                file_size = struct.unpack('<I', f.read(4))[0]
                acon = f.read(4)
                if acon != b'ACON':
                    print(f"Not a valid ANI file: {filepath}")
                    return frames_data, delay

                # Parse chunks
                num_frames = 0
                frame_index = 0

                while f.tell() < file_size + 8:
                    try:
                        chunk_type = f.read(4)
                        if len(chunk_type) < 4:
                            break
                        chunk_size = struct.unpack('<I', f.read(4))[0]

                        if chunk_type == b'anih':
                            # Animation header
                            chunk_data = f.read(chunk_size)
                            header_size = struct.unpack('<I', chunk_data[0:4])[0]
                            num_frames = struct.unpack('<I', chunk_data[4:8])[0]

                        elif chunk_type == b'rate':
                            # Frame rate data
                            chunk_data = f.read(chunk_size)
                            rates = struct.unpack(f'<{chunk_size//4}I', chunk_data)
                            if rates:
                                delay = rates[0]  # in jiffies

                        elif chunk_type == b'LIST':
                            # Save position to read chunk_data
                            list_start = f.tell()
                            list_type = f.read(4)

                            if list_type == b'fram':
                                # Parse frame icons
                                while f.tell() < list_start + chunk_size:
                                    try:
                                        icon_header = f.read(4)
                                        if icon_header != b'icon':
                                            # Try to find next icon chunk
                                            f.seek(-3, 1)
                                            continue

                                        icon_size = struct.unpack('<I', f.read(4))[0]
                                        icon_data = f.read(icon_size)

                                        # Save icon to temp file
                                        temp_cur = self.temp_dir / f'frame_{frame_index}.cur'
                                        with open(temp_cur, 'wb') as icon_file:
                                            icon_file.write(icon_data)

                                        # Extract hotspot and save frame info
                                        hx, hy = self.read_cur_hotspot(temp_cur)
                                        frames_data.append({
                                            'file': temp_cur,
                                            'hotspot_x': hx,
                                            'hotspot_y': hy,
                                            'index': frame_index
                                        })

                                        frame_index += 1
                                    except Exception as e:
                                        print(f"Error parsing frame: {e}")
                                        break

                            else:
                                # Skip this LIST chunk
                                f.seek(list_start + chunk_size)

                        else:
                            # Skip unknown chunk
                            f.seek(chunk_size, 1)

                        # Align to 2-byte boundary
                        if chunk_size % 2:
                            f.read(1)

                    except Exception as e:
                        print(f"Error parsing ANI chunk in {filepath}: {e}")
                        break

        except Exception as e:
            print(f"Error reading ANI file {filepath}: {e}")

        return frames_data, delay

    def create_xcursor_config(self, config_file, images_info, delay_ms=0):
        """Create a config file for xcursorgen"""
        with open(config_file, 'w') as f:
            for img_info in images_info:
                png_file = img_info['png']
                size = img_info['size']
                hotspot_x = img_info['hotspot_x']
                hotspot_y = img_info['hotspot_y']
                # Format: size hotspot_x hotspot_y image_path [delay]
                if delay_ms > 0:
                    f.write(f"{size} {hotspot_x} {hotspot_y} {png_file} {delay_ms}\n")
                else:
                    f.write(f"{size} {hotspot_x} {hotspot_y} {png_file}\n")

    def convert_static_cursor(self, input_file, output_name):
        """Convert a static .cur file to X11 cursor"""
        input_path = self.source_dir / input_file
        output_path = self.output_dir / 'cursors' / output_name

        # Extract hotspot
        hotspot_x, hotspot_y = self.read_cur_hotspot(input_path)

        # Convert to PNG (may create multiple files for different sizes)
        png_pattern = self.temp_dir / f'{output_name}-%d.png'
        png_files = self.extract_cur_to_png(input_path, png_pattern)

        if not png_files:
            return False

        # Process each size
        try:
            images_info = []
            for png_file in png_files:
                img = Image.open(png_file)
                size = max(img.size)
                images_info.append({
                    'png': png_file,
                    'size': size,
                    'hotspot_x': hotspot_x,
                    'hotspot_y': hotspot_y
                })

            # Create xcursorgen config
            config_file = self.temp_dir / f'{output_name}.in'
            self.create_xcursor_config(config_file, images_info)

            # Generate X11 cursor
            subprocess.run(['xcursorgen', str(config_file), str(output_path)], check=True, capture_output=True)
            print(f"Converted {input_file} -> {output_name} ({len(png_files)} sizes)")
            return True

        except Exception as e:
            print(f"Error converting {input_file}: {e}")
            return False

    def convert_animated_cursor(self, input_file, output_name):
        """Convert an animated .ani file to X11 cursor"""
        input_path = self.source_dir / input_file
        output_path = self.output_dir / 'cursors' / output_name

        # Parse ANI file
        frames_data, delay_jiffies = self.read_ani_file(input_path)

        if not frames_data:
            print(f"No frames found in {input_file}")
            return False

        # Convert delay from jiffies (1/60s) to milliseconds
        delay_ms = int(delay_jiffies * 1000 / 60)

        # Convert each frame to PNG
        images_info = []
        for frame in frames_data:
            png_pattern = self.temp_dir / f"{output_name}_frame_{frame['index']}-%d.png"

            png_files = self.extract_cur_to_png(frame['file'], png_pattern)
            if png_files:
                # Use the first (smallest) size for animated cursors
                try:
                    img = Image.open(png_files[0])
                    size = max(img.size)

                    images_info.append({
                        'png': png_files[0],
                        'size': size,
                        'hotspot_x': frame['hotspot_x'],
                        'hotspot_y': frame['hotspot_y']
                    })
                except Exception as e:
                    print(f"Error reading frame PNG: {e}")

        if not images_info:
            print(f"Failed to convert frames for {input_file}")
            return False

        # Create xcursorgen config
        config_file = self.temp_dir / f'{output_name}.in'
        self.create_xcursor_config(config_file, images_info, delay_ms)

        # Generate X11 cursor
        try:
            subprocess.run(['xcursorgen', str(config_file), str(output_path)], check=True, capture_output=True)
            print(f"Converted {input_file} -> {output_name} ({len(images_info)} frames, {delay_ms}ms delay)")
            return True
        except subprocess.CalledProcessError as e:
            print(f"Error running xcursorgen for {input_file}: {e}")
            return False

    def convert_cursor(self, input_file, output_name):
        """Convert a single cursor file"""
        if input_file.endswith('.cur'):
            return self.convert_static_cursor(input_file, output_name)
        elif input_file.endswith('.ani'):
            return self.convert_animated_cursor(input_file, output_name)
        return False

    def create_theme_structure(self, theme_name):
        """Create the Linux cursor theme directory structure"""
        theme_dir = self.output_dir
        cursors_dir = theme_dir / 'cursors'
        cursors_dir.mkdir(parents=True, exist_ok=True)
        return theme_dir, cursors_dir

    def create_index_theme(self, theme_name):
        """Create index.theme file"""
        # Detect if it's light or dark theme
        theme_type = "light" if "Light" in theme_name else "dark"
        index_content = f"""[Icon Theme]
Name={theme_name}
Comment=Minimalist {theme_type} cursor theme
"""
        index_path = self.output_dir / 'index.theme'
        with open(index_path, 'w') as f:
            f.write(index_content)
        print(f"Created index.theme")

    def create_symlinks(self):
        """Create symlinks for cursor name mappings"""
        cursors_dir = self.output_dir / 'cursors'

        # Mapping of base cursor names to their X11 aliases
        mappings = {
            'default': ['arrow', 'top_left_arrow', 'left_ptr'],
            'pointer': ['hand2', 'hand1', 'pointing_hand', 'hand'],
            'help': ['question_arrow', 'whats_this'],
            'wait': ['watch'],
            'progress': ['left_ptr_watch', 'half-busy'],
            'crosshair': ['cross', 'tcross'],
            'text': ['ibeam', 'xterm'],
            'pencil': ['pencil', 'draft'],
            'no-drop': ['not-allowed', 'forbidden', 'circle'],
            'v-resize': ['sb_v_double_arrow', 'v_double_arrow', 'size_ver', 'split_v', 'row-resize', 'ns-resize'],
            'h-resize': ['sb_h_double_arrow', 'h_double_arrow', 'size_hor', 'split_h', 'col-resize', 'ew-resize'],
            'nwse-resize': ['fd_double_arrow', 'size_fdiag', 'bottom_right_corner', 'top_left_corner', 'nwse-resize'],
            'nesw-resize': ['bd_double_arrow', 'size_bdiag', 'bottom_left_corner', 'top_right_corner', 'nesw-resize'],
            'move': ['fleur', 'size_all', 'all-scroll', 'grabbing'],
            'alternate': ['up_arrow', 'center_ptr'],
            'link': ['alias', 'dnd-link'],
            'pin': ['center_ptr'],
            'person': ['person'],
        }

        # Create symlinks
        for base_name, aliases in mappings.items():
            base_path = cursors_dir / base_name
            if base_path.exists():
                for alias in aliases:
                    link_path = cursors_dir / alias
                    if not link_path.exists():
                        try:
                            os.symlink(base_name, link_path)
                        except Exception as e:
                            print(f"Warning: Could not create symlink {alias}: {e}")

        print("Created cursor symlinks")

    def cleanup(self):
        """Clean up temporary files"""
        import shutil
        if self.temp_dir.exists():
            shutil.rmtree(self.temp_dir)

def main():
    script_dir = Path(__file__).parent
    # Detect theme name from source directory
    theme_dir_name = script_dir.name
    output_name = 'Dot-Light'
    output_dir = script_dir.parent / output_name

    converter = CursorConverter(script_dir, output_dir)

    try:
        # Create theme structure
        print("Creating theme structure...")
        theme_name = script_dir.name  # Use the actual directory name as theme name
        theme_dir, cursors_dir = converter.create_theme_structure(theme_name)

        # Cursor file mapping
        cursor_mapping = {
            '01_normal_select.cur': 'default',
            '02_help_select.cur': 'help',
            '03_working_in_background.ani': 'progress',
            '04_busy.ani': 'wait',
            '05_precision_select.cur': 'crosshair',
            '06_text_select.cur': 'text',
            '07_handwriting.cur': 'pencil',
            '08_unavailable.cur': 'no-drop',
            '09_vertical_resize.cur': 'v-resize',
            '10_horizontal_resize.cur': 'h-resize',
            '11_diagonal_resize_1.cur': 'nwse-resize',
            '12_diagonal_resize_2.cur': 'nesw-resize',
            '13_move.cur': 'move',
            '14_alternate_select.cur': 'alternate',
            '15_link_select.cur': 'link',
            '16_location_select.cur': 'pin',
            '17_person_select.cur': 'person',
        }

        # Convert cursors
        print("\nConverting cursors...")
        success_count = 0
        for windows_file, linux_name in cursor_mapping.items():
            if converter.convert_cursor(windows_file, linux_name):
                success_count += 1

        # Also create 'pointer' as copy of 'pencil' for hand cursor
        pointer_src = cursors_dir / 'pencil'
        pointer_dst = cursors_dir / 'pointer'
        if pointer_src.exists() and not pointer_dst.exists():
            import shutil
            shutil.copy(pointer_src, pointer_dst)

        # Create index.theme
        print("\nCreating index.theme...")
        converter.create_index_theme(theme_name)

        # Create symlinks
        print("Creating symlinks...")
        converter.create_symlinks()

        print(f"\n{'='*60}")
        print(f"Conversion complete! Successfully converted {success_count}/{len(cursor_mapping)} cursors")
        print(f"Theme saved to: {output_dir}")
        print(f"\nTo install:")
        print(f"  mkdir -p ~/.icons")
        print(f"  cp -r {output_dir} ~/.icons/")
        print(f"  Then select the theme in your system settings")
        print(f"{'='*60}")

    finally:
        # Clean up temp files
        converter.cleanup()

if __name__ == '__main__':
    main()
