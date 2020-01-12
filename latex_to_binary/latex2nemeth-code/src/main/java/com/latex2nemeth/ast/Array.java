package com.latex2nemeth.ast;

import com.latex2nemeth.symbols.NemethTable;

import java.util.Vector;

public class Array extends Expression {
    private Vector<Expression> row;
    private Vector<Expression[]> rows;
    private Vector<Expression> currentRow;
    private String ematrix[][];
    private int nrows, ncols;
    private int height;
    // For rendering...
    private Vector<Vector<String>> columns;

    public Array(Vector<Expression[]> ar, NemethTable table) {
        super(table);
        rows = ar;
    }

    public void addExpression(Expression e) {
        currentRow.add(e);
    }

    @Override
    public void assignFractionLevel() {

    }

    @Override
    public void assignOtherLevels() {

    }

    @Override
    public String getBraille() {
        StringBuffer buffer;
        createMatrix();
        int i, j;
        int colwidths[] = new int[ncols];

        for (j = 0; j < ncols; j++) {
            for (i = 0; i < nrows; i++) {
                String sexp = ematrix[i][j];
                if (colwidths[j] < sexp.length())
                    colwidths[j] = sexp.length();
            }
        }

        buffer = new StringBuffer();
        buffer.append("\n");
        for (i = 0; i < nrows; i++) {
            for (j = 0; j < ncols; j++) {
                buffer.append(ematrix[i][j]);
                int spaces = colwidths[j] - ematrix[i][j].length();
                for (int k = 0; k <= spaces; k++) {
                    buffer.append(" ");
                }
            }
            buffer.append("\n");
        }

        return buffer.toString();
    }

    protected void createMatrix() {

        nrows = rows.size();
        ncols = rows.elementAt(0).length;

        height = ncols;

        ematrix = new String[nrows][ncols];
        int i, j;

        i = 0;
        for (Expression[] r : rows) {
            for (j = 0; j < ncols; j++) {
                if (r[j] != null)
                    ematrix[i][j] = r[j].getBraille();
                else
                    ematrix[i][j] = " ";
            }
            i++;
        }
    }
}
