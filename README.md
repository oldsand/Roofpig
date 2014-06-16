#RoofPig

Roofpig is an animated, programmable and interactive Rubik's Cube for the modern web. It uses WebGL or plain Canvas (by way of [three.js](http://threejs.org/)) and is written in CoffeeScript. You can see it used on my site http://lar5.com/cube/

##1. Usage

Get roofpig_and_three.min.js and roofpig.css from https://github.com/larspetrus/Roofpig/tree/master/download. Then include them (and jQuery) in the HEAD tag of your html pages like this:

```html
<link rel="stylesheet" href="roofpig.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="roofpig_and_three.min.js"></script>
```

To make a cube to appear on the page, you only need to make a div with class='roofpig', and configuration in a data-config attribute.

```html
<div class=roofpig data-config="alg=R U R' U R U2 R'"></div>
```

**Dependencies**

Roofpig needs jQuery, three.js and a modern canvas enabled browser to work.


##2. Configuration

This makes a fully configured example cube:

```html
<div class=roofpig style="width=140px; height=160px;"
  data-config="alg=R U' F+B' R2 F'+B U' R'|solved=UR-|colored=U U-|colors=F:B B:G U:R D:O R:W L:Y">
</div>
```

As you can see, the data-config format is *"prop1=something|prop2=something else|prop99=blah"*.

Valid properties are: *alg, algdisplay, base, colored, colors, flags, hover, pov, setup, solved, tweaks*, but we'll go over them in a logical order.

###2.1 Algorithm

Properties: *alg, flags:showalg*

The algorithm to animate is defined like this: *alg=R F' x2 R D Lw'*. It handles standard cube notation and then some. If no alg is given, the cube will appear without the playback buttons.

####Standard notation

Roofpig supports (almost) all standard cube notation. 

Layer(s): **F, B, R, L, U, D. M, E, S. x, y, z. Fw, Bw, Rw, Lw, Uw, Dw**.

Turns: **2, ', 2'**. You can also use **², Z, 1** and **3**.


####Roofpig extras

The standard slice and turn moves change the names of the cube sides. This is really impractical if you have a solution in **FBRLUD** and want to show the interesting parts to the user.

So Roofpig has "soft" rotations - which you can also think of as moving the "camera". **R>** rotates the whole cube like an **R** move. **R>>** corresponds to **R2**, **R<** and **R<<** to **R'** and **RZ**. Yes, **F>** is the same as **B<**.

Roofpig also allows combining moves. So you can do orientation safe slice moves like this: M = **L'+R**, E = **D'+U** and S = **F'+B**. And the 'w' moves like this: Rw = **R>+L**, Lw = **L>+R**, Uw = **U>+D**, Dw = **D>+U**, Fw = **F>+B**, Bw = **B>+F**

If you combine moves that can't be done in parallell, like **L+U** or **Rw+Fw2**, horrible and amusing things will happen

I could write much more, but trying things out in JSFiddle is probably more useful. Note that you can change the HTML and click Run to experiment. Here: http://jsfiddle.net/Lar5/MfpVf/

###2.2 Defining 'solved'

Properties: *colored, solved, tweaks, setup*

So we need to define how the cube looks when the alg has been performed. By default, it will be a regular full 6 color cube. But you can also mark some parts as 'solved' (dark gray) or 'ignored' (light gray), move things around and more.

But first we need to talk about Cubexp.

####Cubexps

We often need to define sets of stickers. So I invented the "Cubexp" language to talk about logical groups of stickers in a simple way.

Cubexps do one thing: Define a set stickers, out of the 54 on a cube. That's it. They do nothing else.

The simplest format is listing pieces. **UBL** selects all the stickers on the UBL corner piece. This selects the whole U layer: **"U UB UBL UBR UF UFL UFR UL UR"**. Listing more pieces adds to the selection. Note that **U** is the center piece in Cubex, not the side or layer.

To select individual stickers on a piece, use upper case and lower case letters. So the U *side* can be selected like this: **"U Ub Ubl Ubr Uf Ufl Ufr Ul Ur"**.

This would be enough to define anything. It would also be tedious. So we have some shorthand formats.

- __F*__. Whole layers. __U*__ is the same as **"U UB UBL UBR UF UFL UFR UL UR"**. __UF*__ adds **"DF DFL DFR F FL FR"** to that.
- __F-__. Everything *not* in these layers. **U-** is the same as **"U Ub Ubl Ubr Uf Ufl Ufr Ul Ur"**. **ULB-** is **"D DF DFR DR F FR R"** (the DFR 2x2x2 block).
- __f__. A whole side. "u" is the same as "U Ub Ubl Ubr Uf Ufl Ufr Ul Ur".
- __*__. The whole cube. Useful for filtering (see below)
- __Filtering__. You can filter any shorthand to only select certain piece types. c = corners, e = edges and m = middles. Like this: **U*/c** is all the corners in the U layer, or **"UBL UBR UFL UFR"**. u/me is **"U Ub Uf Ul Ur"**. You get the idea.

Cubexp JS Fiddle: http://jsfiddle.net/Lar5/2xAVX/


####Setting up cube stickers.

Now that we know Cubexps, we can set up cubes!

#####solved and colored
The main parameters for this are *solved* and *colored*. *solved* stickers will be dark grey. *colored* stickers will have their normal colors. Any others will be the light gray as 'ignored'. *solved* trumps *colored*.

Solved and colored JSFiddle: http://jsfiddle.net/Lar5/tE83s/

#####setupmoves and tweaks
If just coloring stickers shades of gray on the solved cube is not enough, there are two parameters.

- *setupmoves* describe how to get from a solved cube to the cube you want finishing the alg will be. So "setupmoves=L' B' R B L B' R' B" gives a cube with 3 permuted corners.
- *tweaks* is the free form tool, where you can set any sticker to any color - AND MORE! "tweaks=F:RF" sets both stickers on the FR edge to the F color. "tweaks=R:Ubl" sets only the U sticker on the UBL corner to the R color. On top of colors, you can also but Xes on stickers like this: tweaks="X:Ub x:Ul:

The JSFiddle is extra useful for this stuff: TODO

###2.3 The other parameters

####2.3.1 hover

How far out do the hidden side stickers hover away from the cube? Numbers from 1.1 to around 8 are useful, but you can also use the aliases 'none', 'near' and 'far'.

####2.3.1 flags

Things that can only be on or off are set to "ON" by mentioning them in this free form text field. Current flags are 
- *showalg* - Display the alg, according to the *algdisplay* setting.
- *canvas* - Use regular 2D canvas to draw instead of WebGL.

####2.3.1 colors

By default, Roofpig uses the colors I like: R=green, L=blue, F=red, B=orange, U=yellow, D=white. To set that using this parameter, you'd use "colors=R:G L:B F:R B:O U:Y D:W". To set L to red is "L:R". I hope the pattern is clear. Aside from the short color names G, B, R, O, Y and W, you can also use any CSS color, such as 'pink', #77f or #3d3dff.

JSFiddle: XXX 

####2.3.1 pov

By default the Point Of View is on the UFR corner, with U on top. To look at DFL with F on top, use "pov=Fdl"

####2.3.1 algdisplay

This defines how algs are display if the showalg flag is set. Much like flags, it's a free form string, where we look for certain commands:
- *fancy2s* - Double moves are written F² rather than F2.
- *rotations* - Displays the Roofpig rotations. By default they are not displayed.
- *2p* - Display counter clockwise double moves as 2'
- *Z* - Display counter clockwise double moves as Z


###2.4 base - defining defaults.

By now you may be asking, "But Lars, what if I use the Japanese color scheme? Do I really have to specify that in each and every cube config?". To that I say, "No, dear infomercial plant, Roofpig has a simple way to share common config, which both cuts down on repetition and makes the common parts easy and safe to change.

You simply put the common part in a Javascript variably, named starting with **"ROOFPIG_CONF_"**.

```html
<script>
  ROOFPIG_CONF_F5 = "solved=U- | colors=F:B B:G U:R D:O R:W L:Y"
</script>
<div class=roofpig data-config="base=F5|alg=L+R' U' R U L' U' R' U R"></div>
<div class=roofpig data-config="base=F5|alg=R' U' R U L U' R' U R+L'"></div>
```

This shares it within a page. To share across a whole site, you can put some **"ROOFPIG_CONF_"**'s in a .js file that you include everywhere.