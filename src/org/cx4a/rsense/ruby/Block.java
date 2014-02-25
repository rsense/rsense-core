package org.cx4a.rsense.ruby;

import org.jrubyparser.ast.Node;

public interface Block {
    public Node getVarNode();
    public Node getBodyNode();
    public Frame getFrame();
    public Scope getScope();
}
