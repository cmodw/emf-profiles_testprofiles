package inhibitorArcs.aspect;

import org.modelversioning.emfprofile.application.registry.ProfileApplicationRegistry;
import org.modelversioning.emfprofile.application.registry.ui.observer.ActiveEditorObserver;
import org.modelversioning.emfprofileapplication.StereotypeApplication;

import petrinet.Node;
import petrinet.Place;

public aspect profile {

	boolean around(petrinet.Arc eObject): target(eObject) && execution(boolean isEnabled()) {
		String stereotypeID = "http://test/petrinet/inhibitorArcsinhibitorArc";
		String modelId = ActiveEditorObserver.INSTANCE.getModelIdForLastActiveWorkbenchPart();
		StereotypeApplication stereotypeApplication = ProfileApplicationRegistry.INSTANCE.getStereotypeApplication(modelId, eObject, stereotypeID);
		if(stereotypeApplication != null) {
			Node node = eObject.getSource();
			if (node instanceof Place) {
				if(((Place) node).getTokens().size() == 0)
					return true;
			}
			return false;
		} else {
			return proceed(eObject);
		}

	}
}