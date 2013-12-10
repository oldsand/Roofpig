#= require three.min
#= require roofpig/Colors
#= require roofpig/Side

describe "Colors", ->
  describe "of", ->
    it "has default values", ->
      colors = new Colors("", "", "")
      expect(colors.of(Side.R)).to.equal('#0d0')
      expect(colors.of(Side.L)).to.equal('blue')
      expect(colors.of(Side.F)).to.equal('red')
      expect(colors.of(Side.B)).to.equal('orange')
      expect(colors.of(Side.U)).to.equal('yellow')
      expect(colors.of(Side.D)).to.equal('#eee'  )
      expect(colors.of('solved')).to.equal('#666')
      expect(colors.of('ignored')).to.equal('#aaa')

      expect(-> colors.of('UNKNOWN')).to.throw(Error)
    
    it "can set side colors", ->
      colors = new Colors("", "", "R:O L:#abc solved:R")

      expect(colors.of(Side.R)).to.equal('orange')
      expect(colors.of(Side.L)).to.equal('#abc')
      expect(colors.of('solved')).to.equal('red')

      expect(colors.of(Side.U)).to.equal('yellow')
      expect(colors.of(Side.D)).to.equal('#eee'  )

  describe "#to_draw", ->
    it "is colored by default", ->
      colors = new Colors("", "")
      expect(colors.to_draw('UFR', Side.F).color).to.equal(colors.of(Side.F))
      expect(colors.to_draw('DB', Side.B).color).to.equal(colors.of(Side.B))
      expect(colors.to_draw('L', Side.L).color).to.equal(colors.of(Side.L))

    it "colors only specified stickers", ->
      colors = new Colors("U*", "")
      expect(colors.to_draw('UFR', Side.F).color).to.equal(colors.of(Side.F))
      expect(colors.to_draw('DB', Side.B).color).to.equal(colors.of('ignored'))
      expect(colors.to_draw('L', Side.L).color).to.equal(colors.of('ignored'))

    it "solved overrides colored", ->
      colors = new Colors("U*", "F*")
      expect(colors.to_draw('UFR', Side.F).color).to.equal(colors.of('solved'))
      expect(colors.to_draw('UR', Side.U).color).to.equal(colors.of(Side.U))
      expect(colors.to_draw('F', Side.F).color).to.equal(colors.of('solved'))
      expect(colors.to_draw('L', Side.L).color).to.equal(colors.of('ignored'))
