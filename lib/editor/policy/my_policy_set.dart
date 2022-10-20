import '../../diagram.dart';
import '/diagram_editor.dart';
import '/editor/policy/canvas_policy.dart';
import '/editor/policy/canvas_widgets_policy.dart';
import '/editor/policy/component_design_policy.dart';
import '/editor/policy/component_policy.dart';
import '/editor/policy/component_widgets_policy.dart';
import '/editor/policy/custom_policy.dart';
import '/editor/policy/init_policy.dart';
import '/editor/policy/link_attachment_policy.dart';
import '/editor/policy/link_widgets_policy.dart';
import '/editor/policy/my_link_control_policy.dart';
import '/editor/policy/my_link_joint_control_policy.dart';

class MyPolicySet extends PolicySet
    with
        CustomPolicy,
        MyInitPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        MyComponentDesignPolicy,
        MyLinkControlPolicy,
        MyLinkJointControlPolicy,
        MyLinkWidgetsPolicy,
        MyLinkAttachmentPolicy,
        MyCanvasWidgetsPolicy,
        MyComponentWidgetsPolicy,
        //
        CanvasControlPolicy,
        //
        CustomStatePolicy,
        CustomBehaviourPolicy {}
