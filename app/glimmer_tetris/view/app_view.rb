# Copyright (c) 2021 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require_relative '../model/game'

require_relative 'playfield'
require_relative 'score_lane'
require_relative 'high_score_dialog'
require_relative 'tetris_menu_bar'

class GlimmerTetris
  module View
    class AppView
      include Glimmer::UI::CustomShell

      attr_reader :game
      
      before_body {
        @mutex = Mutex.new
        @game = Model::Game.new
            
        @game.configure_beeper do
          display.beep
        end
        
        Display.app_name = 'Glimmer Tetris'
    
        display {
          on_swt_keydown { |key_event|
            case key_event.keyCode
            when swt(:arrow_down), 's'.bytes.first
              if OS.mac?
                game.down!
              else
                # rate limit downs in Windows/Linux as they go too fast when key is held
                @queued_downs ||= 0
                @queued_downs += 1
                async_exec do
                  game.down! if @queued_downs < 3
                  @queued_downs -= 1
                end
              end
            when swt(:arrow_up)
              case game.up_arrow_action
              when :instant_down
                game.down!(instant: true)
              when :rotate_right
                game.rotate!(:right)
              when :rotate_left
                game.rotate!(:left)
              end
            when swt(:arrow_left), 'a'.bytes.first
              game.left!
            when swt(:arrow_right), 'd'.bytes.first
              game.right!
            when swt(:shift), swt(:alt)
              if key_event.keyLocation == swt(:right) # right shift key
                game.rotate!(:right)
              elsif key_event.keyLocation == swt(:left) # left shift key
                game.rotate!(:left)
              end
            end
          }
    
          # if running in app mode, set the Mac app about dialog (ignored in platforms)
          on_about {
            show_about_dialog
          }
          
          on_quit {
            exit(0)
          }
        }
      }
      
      after_body {
        observe(@game, :game_over) do |game_over|
          if game_over
            show_high_score_dialog
          else
            start_moving_tetrominos_down
          end
        end
        observe(@game, :show_high_scores) do |show_high_scores|
          if show_high_scores
            show_high_score_dialog
          else
            @high_score_dialog.close unless @high_score_dialog.nil? || @high_score_dialog.disposed? || !@high_score_dialog.visible?
          end
        end
        @game.start!
      }
      
      body {
        shell(:no_resize) {
          grid_layout 2, false
          text 'Glimmer Tetris'
          minimum_size 500, 500
          
          tetris_menu_bar(game: @game)
          
          playfield(game_playfield: @game.playfield, playfield_width: Model::Game::PLAYFIELD_WIDTH, playfield_height: Model::Game::PLAYFIELD_HEIGHT)
          
          score_lane(game: @game) {
            layout_data(:fill, :fill, true, true)
          }
        }
      }
      
      def start_moving_tetrominos_down
        Thread.new do
          @mutex.synchronize do
            loop do
              time = Time.now
              sleep @game.delay
              break if @game.game_over? || body_root.disposed?
              # ensure entire game tetromino down movement happens as one GUI update event with sync_exec (to avoid flicker/stutter)
              sync_exec { @game.down! unless @game.paused? }
            end
          end
        end
      end
      
      def show_high_score_dialog
        return if @high_score_dialog&.visible?
        @high_score_dialog = high_score_dialog(parent_shell: body_root, game: @game) if @high_score_dialog.nil? || @high_score_dialog.disposed?
        @high_score_dialog.show
      end
      
      def show_about_dialog
        message_box {
          text 'Glimmer Tetris'
          message "Glimmer Tetris\n\nGlimmer DSL for SWT Sample\n\nCopyright (c) 2021 Andy Maleh"
        }.open
      end
    end
  end
end
