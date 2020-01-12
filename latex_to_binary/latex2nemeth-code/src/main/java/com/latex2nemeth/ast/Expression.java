package com.latex2nemeth.ast;

import com.latex2nemeth.symbols.NemethTable;

public abstract class Expression {
    protected int sqrtlevel = 0;
    protected int sublevel = 0;
    protected int suplevel = 0;
    protected int fractionlevel = 0;
    protected NemethTable table;

    public Expression() {}

    public Expression(NemethTable table) {
        this.table = table;
    }

    public abstract void assignFractionLevel();

    public abstract void assignOtherLevels();

    public abstract String getBraille();
}
