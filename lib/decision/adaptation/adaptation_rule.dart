enum AdaptationAction {
  keepDefault,
  highlightOffer,
  showAssistance,
  showPromotion,
}

class AdaptationDecision {
  const AdaptationDecision({required this.action, this.reason = ''});

  final AdaptationAction action;
  final String reason;
}
