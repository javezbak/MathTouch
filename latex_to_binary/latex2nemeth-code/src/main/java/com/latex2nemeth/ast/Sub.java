package com.latex2nemeth.ast;

import com.latex2nemeth.symbols.NemethTable;

public class Sub extends Expression {

    private Expression base, sub;

    public Sub(Expression base, Expression sub, NemethTable table) {
        super(table);
        this.base = base;
        this.sub = sub;
//		sub.sublevel = base.sublevel + 1;
    }

    @Override
    // ?? What do we do here?
    public void assignFractionLevel() {
        base.assignFractionLevel();
        sub.assignFractionLevel();

        this.fractionlevel = 0; // base.fractionlevel;

//		sub.sublevel = base.sublevel + 1;
//		base.assignFractionLevels();
//		sub.assignFractionLevels();
    }

    @Override
    public void assignOtherLevels() {
        base.sublevel = this.sublevel;
        sub.sublevel = this.sublevel + 1;
        base.suplevel = this.suplevel;
        sub.suplevel = this.suplevel;
        base.sqrtlevel = this.sqrtlevel;
        sub.sqrtlevel = this.sqrtlevel;

        base.assignOtherLevels();
        sub.assignOtherLevels();
    }

    @Override
    public String getBraille() {
        // Page 111
        StringBuffer buffer = new StringBuffer();
        String subcode = table.getMathCode("\\sub");
        String basecode = table.getMathCode("\\base");

        buffer.append(base.getBraille());
        for (int i = 0; i <= sublevel; i++) {
            buffer.append(subcode);
        }
        buffer.append(sub.getBraille());
        if (sublevel == 0) {
            buffer.append(basecode);
        }

        return buffer.toString();
    }
}
