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
import org.cx4a.rsense.ruby.Block;
import org.cx4a.rsense.ruby.Context;
import org.cx4a.rsense.ruby.DynamicScope;
import org.cx4a.rsense.ruby.Frame;
import org.cx4a.rsense.ruby.IRubyObject;
import org.cx4a.rsense.ruby.LocalScope;
import org.cx4a.rsense.ruby.Ruby;
import org.cx4a.rsense.ruby.RubyClass;
import org.cx4a.rsense.ruby.RubyModule;
import org.cx4a.rsense.ruby.Scope;
import org.cx4a.rsense.ruby.Visibility;
import org.cx4a.rsense.typing.Graph;
import org.cx4a.rsense.typing.Template;
import org.cx4a.rsense.typing.TemplateAttribute;
import org.cx4a.rsense.typing.TypeSet;
import org.cx4a.rsense.typing.annotation.ClassType;
import org.cx4a.rsense.typing.annotation.MethodType;
import org.cx4a.rsense.typing.annotation.TypeAnnotation;
import org.cx4a.rsense.typing.annotation.TypeExpression;
import org.cx4a.rsense.typing.annotation.TypeVariable;
import org.cx4a.rsense.typing.runtime.AnnotationHelper;
import org.cx4a.rsense.typing.runtime.ClassTag;
import org.cx4a.rsense.typing.runtime.TypeVarMap;
import org.cx4a.rsense.typing.vertex.CallVertex;
import org.cx4a.rsense.typing.vertex.MultipleAsgnVertex;
import org.cx4a.rsense.typing.vertex.ToAryVertex;
import org.cx4a.rsense.typing.vertex.Vertex;
import org.cx4a.rsense.typing.vertex.YieldVertex;
import org.cx4a.rsense.util.Logger;

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
