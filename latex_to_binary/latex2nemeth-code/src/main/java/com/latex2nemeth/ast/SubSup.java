package com.latex2nemeth.ast;

import com.latex2nemeth.symbols.NemethTable;

public class SubSup extends Expression {

    private Expression base, sup, sub;

    public SubSup(Expression base, Expression sub, Expression sup, NemethTable table) {
        super(table);
        this.base = base;
        this.sup = sup;
        this.sub = sub;
    }

    @Override
    public void assignFractionLevel() {
        base.assignFractionLevel();
        sub.assignFractionLevel();
        this.fractionlevel = 0; // base.fractionleve
    }

    @Override
    public void assignOtherLevels() {
        base.sublevel = this.sublevel;
        base.suplevel = this.suplevel;
        base.sqrtlevel = this.sqrtlevel;

        sub.sublevel = this.sublevel + 1;
        sub.suplevel = this.suplevel;
        sub.sqrtlevel = this.sqrtlevel;

        sup.sublevel = this.sublevel;
        sup.suplevel = this.suplevel + 1;
        sup.sqrtlevel = this.sqrtlevel;

        base.assignOtherLevels();
        sub.assignOtherLevels();
        sup.assignOtherLevels();
    }

    @Override
    public String getBraille() {
        StringBuffer buffer = new StringBuffer();
        String subcode = table.getMathCode("\\sub");
        String supcode = table.getMathCode("\\superscript");
        String basecode = table.getMathCode("\\base");

        buffer.append(base.getBraille());
        for (int i = 0; i <= sublevel; i++) {
            buffer.append(subcode);
        }
        buffer.append(sub.getBraille());
        for (int i = 0; i <= suplevel; i++) {
            buffer.append(supcode);
        }
        buffer.append(sup.getBraille());
        if (sublevel == 0) {
            buffer.append(basecode);
        }
        return buffer.toString();
    }

}
