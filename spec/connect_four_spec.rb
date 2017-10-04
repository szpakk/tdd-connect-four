require "spec_helper"
require "connect_four"

RSpec.describe Board do
  let(:game) { Board.new }

  describe "#initialize" do

    it "assigns board representation to 'board' variable" do
      expect(game.board).to eq([[0,0,0,0,0,0,0]] * 6)
    end

    it "initializes @turn variable and assigns it value '0'" do
      expect(game.turn).to eq(0)
    end

    it "initializes @identifier variable and assigns it value '1'" do
      expect(game.identifier).to eq(1)
    end
  end

  describe "#choose_column" do
   
    context "board is clean" do
      it "changes element of last row in board" do  
        game.choose_column(1)
        expect(game.board[-1][0]).not_to eq(0)
      end
    end

    context "board is partially filled" do
      before(:each) do
        game.board[5][0] = 1
      end

      it "changes element of penultimate row if last row is filled" do
        game.choose_column(1)
        expect(game.board[-2][0]).to eq(1)
      end

      it "doesn't change other element in column than last clear" do
        game.choose_column(1)
        expect(game.board[-3][0]).to eq(0)
      end

      it "changes element of last row in board if column is clear" do
        game.choose_column(2)
        expect(game.board[-1][1]).to eq(1)
      end

      it "doesn't change other column elements than last if row is clear" do
        game.choose_column(2)
        expect(game.board[-2][1]).to eq(0)
      end
    end

    context "board is fully filled" do
      it "returns false" do
        game.board = [[1,1,1,1,1,1,1]] * 6
        expect(game.choose_column(1)).to be false
      end
    end   
  end

  describe "#win?" do
    context "4 identifiers in row" do
      it "returns true if 4 same identifiers in a row" do
        game.board[0] = [0,1,1,1,1,0,0]
        expect(game.win?).to be true
      end
      it "returns true if 4 identifiers at the end of a row" do
        game.board[5] = [0,0,0,1,1,1,1]
        expect(game.win?).to be true
      end
      it "returns true if 4 identifiers at the beggining of a row" do
        game.board[3] = [1,1,1,1,0,0,0]
        expect(game.win?).to be true
      end
      it "is not true if less than 4 identifiers in a row" do
        game.board[0] = [0,1,1,1,0,0,0]
        expect(game.win?).not_to be true
      end
    end

    context "different identifiers in a row" do
      it "returns true if 4 same identifiers in a row" do
        game.board[0] = [-1,1,-1,1,1,1,1]
        expect(game.win?).to be true
      end

      it "returns true if 4 negative identifiers in a row" do
        game.board[0] = [1,-1,1,-1,-1,-1,-1]
        expect(game.win?).to be true
      end

      it "doesn't return true if identifiers not in a row" do
        game.board[0] = [-1,1,-1,1,-1,1,-1]
        expect(game.win?).not_to be true
      end
    end

    context "same identifiers in column" do
      it "returns true if 4 same identifiers in a column" do
        4.times { |i| game.board[i][0] = 1 }
        expect(game.win?).to be true
      end

      it "returns true if 4 identifiers at the end of a column" do
        5.downto(2) { |i| game.board[i][0] = 1 }
        expect(game.win?).to be true
      end

      it "is not true if less than 4 identifiers in a column" do 
        3.times { |i| game.board[i][6] = 1 }
        expect(game.win?).not_to be true
      end
    end

    context "different identifiers in a column" do
      it "returns true if 4 same identifers in a column" do
        2.times { |i| game.board[i][0] = -1 }
        5.downto(2) { |i| game.board[i][0] = 1 }
        expect(game.win?).to be true
      end

      it "returns true if 4 negative identifiers in a column" do
        game.board[0][0] = 1
        game.board[-1][0] = 1
        1.upto(4) { |i| game.board[i][0] = -1 }
        expect(game.win?).to be true 
      end

      it "doesn't return true if identifiers not consecutive" do
        [0,2,4].each { |i| game.board[i][0] = 1 }
        [1,3,5].each { |i| game.board[i][0] = -1 }
        expect(game.win?).not_to be true
      end
    end

    context "same identifiers diagonally" do
      it "returns true if 4 identifiers diagonally down right" do
        4.times { |i| game.board[i][i] = 1 }
        expect(game.win?).to be true
      end

      it "returns true if last 4 identifiers diagonally down right" do
        2.upto(5) { |i| game.board[i][i+1] = 1 }
        expect(game.win?).to be true
      end

      it "returns true if 4 identifiers diagonally down left" do
        5.downto(2) { |i| game.board[i][(i-5).abs] = 1 }
        expect(game.win?).to be true
      end

      it "doesn't return true if less than 4 identifiers diagonally" do
        3.times { |i| game.board[i][i] = 1 }
        expect(game.win?).not_to be true
      end
    end

    context "different identifiers diagonally" do
      it "returns true if 4 same identifiers diagonally down right" do
        2.times { |i| game.board[i][i] = -1 }
        2.upto(5) { |i| game.board[i][i] = 1}
        expect(game.win?).to be true
      end

      it "returns true if 4 negative identifiers diagonally" do
        game.board[0][0] = 1
        game.board[5][5] = 1
        1.upto(4) { |i| game.board[i][i] = -1 }
        expect(game.win?).to be true
      end

      it "doesn't return true if 4 identifiers not consecutive diagonally" do
        [0,2,4].each { |i| game.board[i][i] = 1 }
        [1,3,5].each { |i| game.board[i][i] = -1 }
        expect(game.win?).not_to be true
      end
    end
  end

  describe "#new_game" do
    it "changes the turn variable to value '1'" do
      game.new_game
      expect(game.turn).to eq(1)
    end
  end

  describe "assign_player" do
    it "assigns identifier value 1 if turn is odd" do
      game.instance_variable_set('@turn', 1)
      game.assign_player
      expect(game.identifier).to eq(1)
    end

    it "assigns identifier value -1 if turn is even" do
      game.instance_variable_set('@turn', 2)
      game.assign_player
      expect(game.identifier).to eq(-1)
    end
  end
  
  describe "#game_flow", pending => true do
    it "starts new game" do
      expect(game).to receive(:new_game)
      game.game_flow
    end
    it "assigns player at beggining of each turn" do
      expect(game).to receive(:assign_player).at_least(1).times
      game.game_flow
    end

    it "checks if win conditions are met" do
      expect(game).to receive(:win?).at_least(7).times
      game.game_flow
    end
  end

  describe "#validate_input" do
    it "returns integer if input is valid" do
      expect(game.validate_input('7')).to be_between(1,7)
    end

    it "returns false if input is invalid" do
      expect(game.validate_input('aa')).to be false
    end
  end

  describe "#check_full?" do
    it "returns true if column is full" do
      [0,2,4].each { |i| game.board[i][0] = 1 }
      [1,3,5].each { |i| game.board[i][0] = -1 }
      expect(game.check_full?(1)).to be true
    end

    it "returns false if column is not full" do
      [2,4].each { |i| game.board[i][0] = 1 }
      [1,3,5].each { |i| game.board[i][0] = -1 }
      expect(game.check_full?(1)).to be false
    end
  end

  describe "#draw_board" do
    it "prints board representation with no choices made" do
      drawing = " | | | | | | \n"\
                " | | | | | | \n"\
                " | | | | | | \n"\
                " | | | | | | \n"\
                " | | | | | | \n"\
                " | | | | | | \n"\
                "1 2 3 4 5 6 7"
      expect(game.draw_board).to eq(drawing)
    end

    it "prints board representation with choices made" do
      game.choose_column(1)
      game.choose_column(7)
      game.instance_variable_set('@identifier',-1)
      game.choose_column(1)
      drawing = " | | | | | | \n"\
                " | | | | | | \n"\
                " | | | | | | \n"\
                " | | | | | | \n"\
                "X| | | | | | \n"\
                "O| | | | | |O\n"\
                "1 2 3 4 5 6 7"
      expect(game.draw_board).to eq(drawing)
    end
  end
end
