package priority.aspect;

import org.modelversioning.emfprofile.application.registry.ProfileApplicationRegistry;
import org.modelversioning.emfprofile.application.registry.ui.observer.ActiveEditorObserver;
import org.modelversioning.emfprofileapplication.StereotypeApplication;

import petrinet.Node;
import petrinet.PetriNet;
import petrinet.Transition;

public aspect profile {

	boolean around(petrinet.Transition eObject): target(eObject) && execution(boolean isEnabled()) {
		String stereotypeID = "http://test/petrinet/priorPriority";
		String modelId = ActiveEditorObserver.INSTANCE.getModelIdForLastActiveWorkbenchPart();
		StereotypeApplication stereotypeApplication = ProfileApplicationRegistry.INSTANCE.getStereotypeApplication(modelId, eObject, stereotypeID);
		if(stereotypeApplication != null) {
			if (eObject.eContainer() instanceof PetriNet) { 
				int priorityA = (int) stereotypeApplication.eGet(
						stereotypeApplication.getStereotype().getTaggedValue("priority"));
				for (Node node : ((PetriNet) eObject.eContainer()).getNodes()) {
					if(node instanceof Transition) {
						StereotypeApplication sACompare = ProfileApplicationRegistry.INSTANCE.getStereotypeApplication(
								modelId, node, stereotypeID);
						int priorityB = sACompare == null ? 0 : (int) sACompare.eGet(
								sACompare.getStereotype().getTaggedValue("priority"));
						if(priorityB > priorityA && ((Transition)node).isEnabled()){
							return false;
						}
					}
				}
			}
			return proceed(eObject);
		} else {
			return proceed(eObject);
		}

	}
}