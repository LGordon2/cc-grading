# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# create a namespace to export our public methods
connect_four = exports? and exports or @connect_four = {}

$(document).on "ready page:change", ->
  draw_board()
  $(window).resize ->
    update_checkers()
  connect_four.valid_msg "Game started",->
    play_game()

play_game = ->
  return if done("black")
  connect_four.valid_msg "#{players_name("red")}'s Turn", ->
    add_to_col player_move(), "red", ->
      return if done("red")
      connect_four.valid_msg "#{players_name("black")}'s Turn", ->
        add_to_col computer_move(), "black", ->
          play_game()

connect_four.board_string = ->
  board = $("canvas#board")
  all = ("" for i in [1..board.width()/100] for j in [1..board.height()/100])
  $(".checker").each (index,element) ->
    [x,y] = element.id.split("pos")[1].split("_")
    all[y][x] = if $(this).hasClass("red") then "r" else "b"
  all.join(";")

update_checkers = () ->
  board = $("canvas#board")
  board_left = board.position().left
  board_top = board.position().top
  $(".checker").each ->
    [x,y] = @.id.split("pos")[1].split("_")
    $(this).css("left",(parseInt(x)*100+board_left))
    $(this).css("top",(parseInt(y)*100+board_top+2))

check_board = (color) ->
  all_checkers = []
  $(".#{color}.checker").each ->
    [x,y] = @.id.split("pos")[1].split("_")
    all_checkers.push {x:parseInt(x),y:parseInt(y)}
  for checker in all_checkers
    positions = find_four(checker.x,checker.y,all_checkers)
    if positions?
      connect_four.valid_msg "Game completed. #{players_name(color)} wins!", ->
        drawline(positions[0].x,positions[0].y,positions[1].x,positions[1].y)
      return true
  board = $("canvas#board")
  if $(".checker").length == board.height()/100 * board.width()/100
    connect_four.valid_msg("Tie game.")
    return true 
  false
  
find_four = (x,y,a) ->
  #Returns start and end point
  #Go left
  return [{x:x, y:y},{x:x-3,y:y}] if find_four2(x,y,a,0,"left")
  #Go right
  return [{x:x, y:y},{x:x+3,y:y}] if find_four2(x,y,a,0,"right")
  #Go up
  return [{x:x, y:y},{x:x,y:y-3}] if find_four2(x,y,a,0,"up")
  #Go down
  return [{x:x, y:y},{x:x,y:y+3}] if find_four2(x,y,a,0,"down")
  #Go topright
  return [{x:x, y:y},{x:x+3,y:y-3}] if find_four2(x,y,a,0,"topright")
  #Go bottomright
  return [{x:x, y:y},{x:x+3,y:y+3}] if find_four2(x,y,a,0,"bottomright")
  #Go bottomleft
  return [{x:x, y:y},{x:x-3,y:y+3}] if find_four2(x,y,a,0,"bottomleft")
  #Go topleft
  return [{x:x, y:y},{x:x-3,y:y-3}] if find_four2(x,y,a,0,"topleft")

find_four2 = (x,y,a,acc,direction) ->
  included = false
  board = $("canvas#board")
  return true if acc==4
  for object in a
    included = true if (object.x == x && object.y == y)
  return false if not included or x<0 or x>board.width()/100-1 or y<0 or y>board.height()/100-1
  x-=1 if direction == "left" or direction == "bottomleft" or direction == "topleft"
  x+=1 if direction == "right" or direction == "topright" or direction == "bottomright"
  y-=1 if direction == "up" or direction == "topright" or direction == "topleft"
  y+=1 if direction == "down" or direction == "bottomright" or direction == "bottomleft"
  find_four2(x,y,a,acc+1,direction)
  
done = (color) ->
  return check_board(color)

#Private
recursive_add_to_col = (column,row,color,callback) ->
  return connect_four.invalid_msg("Invalid move [#{players_name(color)}] tried to move to column [#{column+1}]") if row < 0 or column < 0 or column > $("canvas#board").width()/100-1
  return connect_four.add column,row,color,callback if $("#pos#{column}_#{row}").length==0
  recursive_add_to_col column,row-1,color,callback

add_to_col = (column,color,callback) ->
  recursive_add_to_col column,$("canvas#board").height()/100-1,color,callback

drawline = (start_col,start_row,end_col,end_row) ->
  board = $("canvas#board")
  board_left = board.position().left
  board_top = board.position().top
  board_ctx = board[0].getContext("2d")
  board_ctx.beginPath()
  board_ctx.moveTo(100*start_col+50,100*start_row+50)
  board_ctx.lineCap="round"
  board_ctx.lineWidth=15;
  board_ctx.lineTo(100*end_col+50,100*end_row+50)
  board_ctx.strokeStyle="#00FF00"
  board_ctx.stroke()
  board_ctx.closePath()

connect_four.valid_msg = (msg, callback) ->
  $("#info_txt").fadeOut ->
    $("#info_txt").text(msg).css("color","white").fadeIn(callback)

connect_four.invalid_msg = (msg, callback) ->
  $("#info_txt").text(msg).css("color","red").fadeOut("fast").fadeIn("fast").fadeOut("fast").fadeIn("fast", callback)
  
connect_four.add = (x,y,color,callback) ->
  board = $("canvas#board")
  board_left = board.position().left
  board_top = board.position().top
  return if x < 0 or x > (board.width()/100 - 1) or y < 0 or y > (board.height()/100 - 1)
  new_img = $("<img src=\"/assets/#{color}.png\" class=\"checker #{color}\" id=\"pos#{x}_#{y}\" style=\"position:absolute;left:#{(x*100+board_left)}px;z-index:-1;\" width=\"100\" height=\"100\">")
  $("canvas:first").first().after(new_img)
  new_img.animate({top:"#{(y*100+board_top+2)}px"},"slow",callback)
          
draw_board = ->
  block = $("canvas#block")[0]
  board = $("canvas#board")[0]    
  block_ctx = block.getContext("2d")
  board_ctx = board.getContext("2d")
  block_ctx.fillStyle="yellow"
  block_ctx.fillRect(0,0,100,100)
  block_ctx.globalCompositeOperation='destination-out';
  block_ctx.beginPath()
  block_ctx.arc(50,50,40,0,2*Math.PI)
  block_ctx.fill()
  block_ctx.stroke()
  block_ctx.closePath()
  
  pat = board_ctx.createPattern(block,'repeat')
  board_ctx.beginPath()
  board_ctx.rect(0,0,board.width,board.height)
  board_ctx.fillStyle=pat
  board_ctx.fill()
  board_ctx.stroke()
  board_ctx.closePath()