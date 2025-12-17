from enum import Enum
from math import prod
import re
from typing import TypeVar

InputData = TypeVar('T')


class Orientation(Enum):
    ROT0_NOFLIP = 0
    ROT90_NOFLIP = 1
    ROT180_NOFLIP = 2
    ROT270_NOFLIP = 3
    ROT0_FLIP = 4
    ROT90_FLIP = 5
    ROT180_FLIP = 6
    ROT270_FLIP = 7


def rotate_ccw(orientation: Orientation) -> Orientation:
    """Rotate the orientation 90 degrees counter-clockwise."""
    orientation_value = orientation.value
    flipped = orientation_value >= 4
    offset = 1 if flipped else -1
    return Orientation((orientation_value + offset) % 4 + (4 if flipped else 0))


def rotate_grid_cw(grid: list[str]) -> list[str]:
    """Rotate a grid 90 degrees clockwise."""
    return [''.join(row[i] for row in grid[::-1]) for i in range(len(grid[0]))]


class Tile:
    def __init__(self, tile_id: int, tile_grid: list[str]):
        self.id = tile_id
        self.grids = self._create_grids(tile_grid)

    def _create_grids(self, grid: list[str]) -> dict[Orientation, list[str]]:
        rot_90_grid = rotate_grid_cw(grid)
        rot_180_grid = rotate_grid_cw(rot_90_grid)
        rot_270_grid = rotate_grid_cw(rot_180_grid)

        grids = {}

        for orientation in Orientation:
            if orientation == Orientation.ROT0_NOFLIP:
                grids[orientation] = grid
            elif orientation == Orientation.ROT90_NOFLIP:
                grids[orientation] = rot_90_grid
            elif orientation == Orientation.ROT180_NOFLIP:
                grids[orientation] = rot_180_grid
            elif orientation == Orientation.ROT270_NOFLIP:
                grids[orientation] = rot_270_grid
            elif orientation == Orientation.ROT0_FLIP:
                grids[orientation] = [row [::-1] for row in grid]
            elif orientation == Orientation.ROT90_FLIP:
                grids[orientation] = [row [::-1] for row in rot_90_grid]
            elif orientation == Orientation.ROT180_FLIP:
                grids[orientation] = [row [::-1] for row in rot_180_grid]
            elif orientation == Orientation.ROT270_FLIP:
                grids[orientation] = [row [::-1] for row in rot_270_grid]

        return grids

    def display(self, orientation) -> None:
        """Display (print) the tile grid in the given orientation."""
        for row in self.grids[orientation]:
            print(row)
        print()

    def tile(self, orientation) -> list[str]:
        """Get the tile grid in the given orientation, without edges."""
        return [''.join(row[1:-1]) for row in self.grids[orientation][1:-1]]

    def edges(self, orientation: Orientation) -> list[str]:
        """Get the edges of the tile in the given orientation.
        Returns edges in CSS order: top, right, bottom, left.
        """
        grid = self.grids[orientation]

        return [
            grid[0],
            ''.join(row[-1] for row in grid),
            grid[-1],
            ''.join(row[0] for row in grid),
        ]


def prepare_input(filename: str) -> InputData:
    with open(filename, 'r') as f:
        lines = [l.strip() for l in f.readlines()]

    tiles = []
    while lines:
        line = lines.pop(0)

        if line == '':
            tiles.append(Tile(tile_id, tile_grid))

        elif line.startswith("Tile"):
            tile_id = int(line[5:-1])
            tile_grid = []
            continue

        else:
            tile_grid.append(line)

    tiles.append(Tile(tile_id, tile_grid))

    return tiles


def _tiles_by_edge(input_data: InputData) -> dict[str, set[int]]:
    tiles_by_edge: dict[str, set[int]] = {}
    for tile in input_data:
        edges = tile.edges(Orientation.ROT0_NOFLIP) + tile.edges(Orientation.ROT180_NOFLIP)
        for edge in edges:
            if edge not in tiles_by_edge:
                tiles_by_edge[edge] = set()
            tiles_by_edge[edge].add(tile.id)

    return tiles_by_edge


def _filter_tiles(input_data: InputData, unique_edges: int) -> set[int]:
    tiles = set()
    for tile in input_data:
        edges = tile.edges(Orientation.ROT0_NOFLIP)
        unique_edge_count = sum(1 for edge in edges if len(_tiles_by_edge(input_data)[edge]) == 1)
        if unique_edge_count == unique_edges:
            tiles.add(tile)

    return tiles


def part1(input_data: InputData):
    corner_tiles = _filter_tiles(input_data, 2)
    tile_ids = set(tile.id for tile in corner_tiles)

    print("Part 1:", tile_ids, "=", prod(tile_ids))


def _get_completed_puzzle(input_data: InputData) -> list[str]:
    puzzle_size = int(input_data.__len__() ** 0.5)
    puzzle: list[list[tuple[Tile, Orientation] | None]] = [[None for _ in range(puzzle_size)] for _ in range(puzzle_size)]
    tiles_by_edge = _tiles_by_edge(input_data)
    corner_tiles = _filter_tiles(input_data, 2)
    edge_tiles = _filter_tiles(input_data, 1)
    central_tiles = set(input_data) - set(corner_tiles) - set(edge_tiles)

    for _ in range(4):
        # Complete the edge with a corner tile followed by 10 edge tiles.
        # Ensure adjacent edges match if there are tiles there.
        for col in range(puzzle_size - 1):
            if col == 0:
                if puzzle[1][0] is None:
                    # First corner placement.
                    first_tile = corner_tiles.pop()
                    for orientation in Orientation:
                        edges = first_tile.edges(orientation)
                        unique_edges = [len(tiles_by_edge[edge]) == 1 for edge in edges]
                        if unique_edges[0] and unique_edges[3]:
                            puzzle[0][0] = (first_tile, orientation)
                            break
                    continue
                else:
                    # Latter corner placement.
                    lower_tile, lower_orientation = puzzle[1][0]
                    matched_edge = lower_tile.edges(lower_orientation)[0]
                    matched_pos = 2
            else:
                # Edge tile placement.
                left_tile, left_orientation = puzzle[0][col - 1]
                matched_edge = left_tile.edges(left_orientation)[1]
                matched_pos = 3

            # Place the tile and remove it from its pool.
            tile_pool = corner_tiles if col == 0 else edge_tiles
            candidate_tiles = [tile for tile in tile_pool if tile.id in tiles_by_edge[matched_edge]]
            for candidate_tile in candidate_tiles:
                for orientation in Orientation:
                    edges = candidate_tile.edges(orientation)
                    if edges[matched_pos] == matched_edge:
                        puzzle[0][col] = (candidate_tile, orientation)
                        tile_pool.remove(candidate_tile)
                        break
                if puzzle[0][col] is not None:
                    break

        # Rotate the puzzle anti-clockwise
        def rotate_tile(tile_with_orientation: tuple[Tile, Orientation] | None) -> tuple[Tile, Orientation] | None:
            if tile_with_orientation is None:
                return None

            tile, orientation = tile_with_orientation
            return (tile, rotate_ccw(orientation))

        puzzle = [[rotate_tile(row[col]) for row in puzzle] for col in range(puzzle_size - 1, -1, -1)]

    # Fill in the center with the remaining tiles.
    for row in range(1, puzzle_size - 1):
        for col in range(1, puzzle_size - 1):
            top_tile, top_orientation = puzzle[row - 1][col]
            left_tile, left_orientation = puzzle[row][col - 1]
            top_edge = top_tile.edges(top_orientation)[2]
            left_edge = left_tile.edges(left_orientation)[1]

            candidate_tiles = [tile for tile in central_tiles if tile.id in tiles_by_edge[top_edge] and tile.id in tiles_by_edge[left_edge]]
            for candidate_tile in candidate_tiles:
                for orientation in Orientation:
                    edges = candidate_tile.edges(orientation)
                    if edges[0] == top_edge and edges[3] == left_edge:
                        puzzle[row][col] = (candidate_tile, orientation)
                        central_tiles.remove(candidate_tile)
                        break
                if puzzle[row][col] is not None:
                    break

    # Build the full image without tile edges.
    image: list[str] = []
    for row in range(puzzle_size):
        tile_rows: list[str] = ['' for _ in range(8)]
        for col in range(puzzle_size):
            tile, orientation = puzzle[row][col]
            tile_content = tile.tile(orientation)
            for i in range(len(tile_rows)):
                tile_rows[i] += tile_content[i]

        image.extend(tile_rows)

    return image


def rotate_grid_cw(grid: list[str]) -> list[str]:
    """Rotate a grid 90 degrees clockwise."""
    return [''.join(row[i] for row in grid[::-1]) for i in range(len(grid[0]))]


def part2(input_data: InputData):
    image = _get_completed_puzzle(input_data)

    monster_row_1 = re.compile(r"..................#.")
    monster_row_2 = re.compile(r"(?=#....##....##....###)")
    monster_row_3 = re.compile(r".#..#..#..#..#..#...")

    for search in range(8):
        if search == 4:
            image = [row [::-1] for row in image]
        image = [''.join(row[i] for row in image[::-1]) for i in range(len(image[0]))]

        num_monsters = 0
        for row in range(1, len(image) - 2):
            for match in monster_row_2.finditer(image[row]):
                col = match.start()
                if monster_row_1.match(image[row - 1][col:col+20]) and monster_row_3.match(image[row + 1][col:col+20]):
                    num_monsters += 1

        if num_monsters > 0:
            break

    num_hashes = sum(row.count('#') for row in image)
    print("Part 2:", num_hashes - num_monsters * 15)
