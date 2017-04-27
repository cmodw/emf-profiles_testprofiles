package time.aspect;

import java.util.Date;

import org.modelversioning.emfprofile.application.registry.ProfileApplicationRegistry;
import org.modelversioning.emfprofile.application.registry.ui.observer.ActiveEditorObserver;
import org.modelversioning.emfprofileapplication.StereotypeApplication;

import petrinet.handlers.FireTransitionCommand;

public aspect profile {

	void around(petrinet.Transition eObject): target(eObject) && execution(void fire()) {
		String stereotypeID = "http://test/petrinet/timetime";
		String modelId = ActiveEditorObserver.INSTANCE.getModelIdForLastActiveWorkbenchPart();
		StereotypeApplication stereotypeApplication = ProfileApplicationRegistry.INSTANCE.getStereotypeApplication(modelId, eObject, stereotypeID);
		if(stereotypeApplication != null) {
						int interval = (int) stereotypeApplication.eGet(
					stereotypeApplication.getStereotype().getTaggedValue("interval"));
			Date lastFire = (Date) stereotypeApplication.eGet(
					stereotypeApplication.getStereotype().getTaggedValue("lastFire"));
			long ms = interval * 1000 + lastFire.getTime();
			if(ms > System.currentTimeMillis())
				return;
			if(eObject.isEnabled())
				new FireTransitionCommand(eObject);
			stereotypeApplication.eSet(
					stereotypeApplication.getStereotype().getTaggedValue("lastFire"), new Date(System.currentTimeMillis()));
		} else {
			proceed(eObject);
		}

	}
}