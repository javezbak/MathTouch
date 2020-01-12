package com.latex2nemeth.ast;

import com.latex2nemeth.symbols.NemethTable;

public class Sup extends Expression {

    private Expression base, sup;

    public Sup(Expression base, Expression sup, NemethTable table) {
        super(table);
        this.base = base;
        this.sup = sup;
//		sup.suplevel = base.suplevel + 1;
    }

    @Override
    public void assignFractionLevel() {
        base.assignFractionLevel();
        sup.assignFractionLevel();
        this.fractionlevel = 0; //base.fractionlevel;
    }

    @Override
    public void assignOtherLevels() {
        base.sublevel = this.sublevel;
        sup.suplevel = this.suplevel + 1;
        base.suplevel = this.suplevel;
        sup.sublevel = this.sublevel;
        base.sqrtlevel = this.sqrtlevel;
        sup.sqrtlevel = this.sqrtlevel;

        base.assignOtherLevels();
        sup.assignOtherLevels();
    }

    @Override
    public String getBraille() {
        // Page 111
        StringBuffer buffer = new StringBuffer();
        String supcode = table.getMathCode("\\superscript");
        String basecode = table.getMathCode("\\base");

        buffer.append(base.getBraille());
        for (int i = 0; i <= suplevel; i++) {
            buffer.append(supcode);
        }
        buffer.append(sup.getBraille());
        if (suplevel == 0) {
            buffer.append(basecode);
        }
        // else? append space?

        return buffer.toString();
    }
}
