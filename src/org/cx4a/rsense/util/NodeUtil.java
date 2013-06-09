package org.cx4a.rsense.util;

import org.jrubyparser.ast.*;
import org.jrubyparser.ast.INameNode;
import org.jrubyparser.NodeVisitor;

public class NodeUtil {
    private static NodeDiff diff = new NodeDiff();

    private NodeUtil() {}

    public static int nodeHashCode(Node node) {
        if (node == null) return 0;
        return new NodeHashCodeCalculator(node).getHashCode();
    }

    public static boolean nodeEquals(Node a, Node b) {
        if ((a == null) ^ (b == null)) {
            return false;
        } else if (a == null) {
            return true;
        }
        return diff.noDiff(a, b);
    }

    private static class NodeHashCodeCalculator implements NodeVisitor {
        private int hashCode;

        public NodeHashCodeCalculator(Node node) {
            hashCode = 0;
            node.accept(this);
        }

        public int getHashCode() {
            return hashCode;
        }

        public Object visitAliasNode(AliasNode node) { return update(0); }
        public Object visitAndNode(AndNode node) { return update(1); }
        public Object visitArgsNode(ArgsNode node) { return update(2); }
        public Object visitArgsCatNode(ArgsCatNode node) { return update(3); }
        public Object visitArgsPushNode(ArgsPushNode node) { return update(4); }
        public Object visitArgumentNode(ArgumentNode node) { return update(5); }
        public Object visitArrayNode(ArrayNode node) { return update(6); }
        public Object visitAttrAssignNode(AttrAssignNode node) { return update(7); }
        public Object visitBackRefNode(BackRefNode node) { return update(8); }
        public Object visitBeginNode(BeginNode node) { return update(9); }
        public Object visitBignumNode(BignumNode node) { return update(10); }
        public Object visitBlockArgNode(BlockArgNode node) { return update(11); }
        public Object visitBlockArg18Node(BlockArg18Node node) { return update(12); }
        public Object visitBlockNode(BlockNode node) { return update(13); }
        public Object visitBlockPassNode(BlockPassNode node) { return update(14); }
        public Object visitBreakNode(BreakNode node) { return update(15); }
        public Object visitConstDeclNode(ConstDeclNode node) { return update(16); }
        public Object visitClassVarAsgnNode(ClassVarAsgnNode node) { return update(17); }
        public Object visitClassVarDeclNode(ClassVarDeclNode node) { return update(18); }
        public Object visitClassVarNode(ClassVarNode node) { return update(19); }
        public Object visitCallNode(CallNode node) { return update(20); }
        public Object visitCaseNode(CaseNode node) { return update(21); }
        public Object visitClassNode(ClassNode node) { return update(22); }
        public Object visitColon2Node(Colon2Node node) { return update(23); }
        public Object visitColon3Node(Colon3Node node) { return update(24); }
        public Object visitConstNode(ConstNode node) { return update(25); }
        public Object visitDAsgnNode(DAsgnNode node) { return update(26); }
        public Object visitDRegxNode(DRegexpNode node) { return update(27); }
        public Object visitDStrNode(DStrNode node) { return update(28); }
        public Object visitDSymbolNode(DSymbolNode node) { return update(29); }
        public Object visitDVarNode(DVarNode node) { return update(30); }
        public Object visitDXStrNode(DXStrNode node) { return update(31); }
        public Object visitDefinedNode(DefinedNode node) { return update(32); }
        public Object visitDefnNode(DefnNode node) { return update(33); }
        public Object visitDefsNode(DefsNode node) { return update(34); }
        public Object visitDotNode(DotNode node) { return update(35); }
        public Object visitEncodingNode(EncodingNode node) { return update(36); }
        public Object visitEnsureNode(EnsureNode node) { return update(37); }
        public Object visitEvStrNode(EvStrNode node) { return update(38); }
        public Object visitFCallNode(FCallNode node) { return update(39); }
        public Object visitFalseNode(FalseNode node) { return update(40); }
        public Object visitFixnumNode(FixnumNode node) { return update(41); }
        public Object visitFlipNode(FlipNode node) { return update(42); }
        public Object visitFloatNode(FloatNode node) { return update(43); }
        public Object visitForNode(ForNode node) { return update(44); }
        public Object visitGlobalAsgnNode(GlobalAsgnNode node) { return update(45); }
        public Object visitGlobalVarNode(GlobalVarNode node) { return update(46); }
        public Object visitHashNode(HashNode node) { return update(47); }
        public Object visitInstAsgnNode(InstAsgnNode node) { return update(48); }
        public Object visitInstVarNode(InstVarNode node) { return update(49); }
        public Object visitIfNode(IfNode node) { return update(50); }
        public Object visitIterNode(IterNode node) { return update(51); }
        public Object visitListNode(ListNode node) { return update(52); }
        public Object visitLiteralNode(LiteralNode node) { return update(53); }
        public Object visitLocalAsgnNode(LocalAsgnNode node) { return update(54); }
        public Object visitLocalVarNode(LocalVarNode node) { return update(55); }
        public Object visitMethodNameNode(MethodNameNode node) { return update(56); }
        public Object visitMultipleAsgnNode(MultipleAsgnNode node) { return update(57); }
        public Object visitMultipleAsgnNode(MultipleAsgn19Node node) { return update(58); }
        public Object visitMatch2Node(Match2Node node) { return update(59); }
        public Object visitMatch3Node(Match3Node node) { return update(60); }
        public Object visitMatchNode(MatchNode node) { return update(61); }
        public Object visitModuleNode(ModuleNode node) { return update(62); }
        public Object visitNewlineNode(NewlineNode node) { return update(63); }
        public Object visitNextNode(NextNode node) { return update(64); }
        public Object visitNilNode(NilNode node) { return update(65); }
        public Object visitNotNode(NotNode node) { return update(66); }
        public Object visitNthRefNode(NthRefNode node) { return update(67); }
        public Object visitOpElementAsgnNode(OpElementAsgnNode node) { return update(68); }
        public Object visitOpAsgnNode(OpAsgnNode node) { return update(69); }
        public Object visitOpAsgnAndNode(OpAsgnAndNode node) { return update(70); }
        public Object visitOpAsgnOrNode(OpAsgnOrNode node) { return update(71); }
        public Object visitOptArgNode(OptArgNode node) { return update(72); }
        public Object visitOrNode(OrNode node) { return update(73); }
        public Object visitPreExeNode(PreExeNode node) { return update(74); }
        public Object visitPostExeNode(PostExeNode node) { return update(75); }
        public Object visitRedoNode(RedoNode node) { return update(76); }
        public Object visitRegexpNode(RegexpNode node) { return update(77); }
        public Object visitRescueBodyNode(RescueBodyNode node) { return update(78); }
        public Object visitRescueNode(RescueNode node) { return update(79); }
        public Object visitRestArgNode(RestArgNode node) { return update(80); }
        public Object visitRetryNode(RetryNode node) { return update(81); }
        public Object visitReturnNode(ReturnNode node) { return update(82); }
        public Object visitRootNode(RootNode node) { return update(83); }
        public Object visitSClassNode(SClassNode node) { return update(84); }
        public Object visitSelfNode(SelfNode node) { return update(85); }
        public Object visitSplatNode(SplatNode node) { return update(86); }
        public Object visitStrNode(StrNode node) { return update(87); }
        public Object visitSuperNode(SuperNode node) { return update(88); }
        public Object visitSValueNode(SValueNode node) { return update(89); }
        public Object visitSymbolNode(SymbolNode node) { return update(90); }
        public Object visitToAryNode(ToAryNode node) { return update(91); }
        public Object visitTrueNode(TrueNode node) { return update(92); }
        public Object visitUndefNode(UndefNode node) { return update(93); }
        public Object visitUntilNode(UntilNode node) { return update(94); }
        public Object visitVAliasNode(VAliasNode node) { return update(95); }
        public Object visitVCallNode(VCallNode node) { return update(96); }
        public Object visitWhenNode(WhenNode node) { return update(97); }
        public Object visitWhileNode(WhileNode node) { return update(98); }
        public Object visitXStrNode(XStrNode node) { return update(99); }
        public Object visitYieldNode(YieldNode node) { return update(100); }
        public Object visitZArrayNode(ZArrayNode node) { return update(101); }
        public Object visitZSuperNode(ZSuperNode node) { return update(102); }

        private Object update(int n) {
            hashCode = hashCode * 13 + n;
            return this;
        }
    }
}
