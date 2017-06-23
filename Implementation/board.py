class Board:
    def __init__(self):
        self.list_pawns = []
        self.selected_pawn = None
        self.positions = [[0] * 5] * 5

    def add_pawn(self, pawn):
        self.list_pawns += pawn
        self.positions[pawn.pos_x][pawn.pos_y] = pawn.side

    def select(self, pawn):
        self.selected_pawn = pawn
        self.selected_pawn.select()

    def unselect(self):
        self.selected_pawn.unselect()
        self.selected_pawn = None

    def move_pawn_to(self, pos_x, pos_y):
        if self.selected_pawn is not None:
            if self.positions[pos_x][pos_y] == 0:
                if 5 > pos_x >= 0 and 5 > pos_y >= 0:
                    self.selected_pawn.move_to(pos_x, pos_y)
        self.unselect()

    def draw_board(self):
        pass

    def draw_pawn(self, pawn):
        pass
