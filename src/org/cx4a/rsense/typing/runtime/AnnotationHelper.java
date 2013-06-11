package org.cx4a.rsense.typing.runtime;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import org.jruby.util.ByteList;
import org.jrubyparser.ast.CommentNode;

import org.antlr.runtime.ANTLRStringStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.RecognitionException;

import org.cx4a.rsense.parser.TypeAnnotationLexer;
import org.cx4a.rsense.parser.TypeAnnotationParser;
import org.cx4a.rsense.typing.Graph;
import org.cx4a.rsense.typing.Template;
import org.cx4a.rsense.typing.annotation.TypeAnnotation;

public class AnnotationHelper {
    private AnnotationHelper() {}

    public static TypeAnnotation parseAnnotation(String annot, int lineno) {
        if (annot.startsWith("#%")) {
            ANTLRStringStream in = new ANTLRStringStream(annot.substring(2));
            in.setLine(lineno);
            TypeAnnotationLexer lex = new TypeAnnotationLexer(in);
            CommonTokenStream tokens = new CommonTokenStream(lex);
            TypeAnnotationParser parser = new TypeAnnotationParser(tokens);
            try {
                return parser.type();
            } catch (RecognitionException e)  {}
        }
        return null;
    }

            // Collection<CommentNode> comments = node.getComments();



    public static List<TypeAnnotation> parseAnnotations(Collection<CommentNode> comments, int lineno) {
        List<TypeAnnotation> annots = new ArrayList<TypeAnnotation>();
        for (Iterator<CommentNode> iterator = comments.iterator(); iterator.hasNext(); )
        {
            CommentNode next = iterator.next();
            String nodeComment = next.getContent();
            TypeAnnotation annot = parseAnnotation(nodeComment, lineno);
            if (annot != null) {
                annots.add(annot);
            }
        }
        return annots;
    }

    public static List<TypeAnnotation> parseAnnotations(List<ByteList> commentList, int lineno) {
        List<TypeAnnotation> annots = new ArrayList<TypeAnnotation>();
        for (ByteList comment : commentList) {
            TypeAnnotation annot = parseAnnotation(comment.toString(), lineno);
            if (annot != null) {
                annots.add(annot);
            }
        }
        return annots;
    }

    public static AnnotationResolver.Result resolveMethodAnnotation(Graph graph, Template template) {
        return new AnnotationResolver(graph).resolveMethodAnnotation(template);
    }
}
