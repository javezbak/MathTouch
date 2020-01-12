package com.latex2nemeth.ast;

import com.latex2nemeth.symbols.NemethTable;

import java.util.Vector;

public class MathExpression extends Expression {

    private Vector<Expression> children = new Vector<Expression>();

    public MathExpression(NemethTable table) {
        super(table);
    }

    public void addChild(Expression e) {
        children.add(e);
    }

    public Expression getChild(int i) {
        return children.elementAt(i);
    }

    @Override
    public void assignFractionLevel() {
        int maxFraction = 0;
        for (Expression e : children) {
            e.assignFractionLevel();
            if (e.fractionlevel > maxFraction)
                maxFraction = e.fractionlevel;
        }
        // this level is the maximum of all other levels...
        this.fractionlevel = maxFraction;
    }

    @Override
    public void assignOtherLevels() {
        for (Expression e : children) {
            e.sqrtlevel = this.sqrtlevel;
            e.sublevel = this.sublevel;
            e.suplevel = this.suplevel;

            e.assignOtherLevels();
        }
    }

    @Override
    public String getBraille() {
        StringBuffer buffer = new StringBuffer();
        for (Expression e : children) {
            buffer.append(e.getBraille());
        }
        return buffer.toString();
    }
}
