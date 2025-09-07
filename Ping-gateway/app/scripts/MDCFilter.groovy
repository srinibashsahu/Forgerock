import org.slf4j.MDC;
import static org.forgerock.openig.el.Functions.logger;

MDC.put("requestid", "");
logger.info("starting MDC filter");
def requestid = request.headers['RequestID']
if (requestid != null && requestid.size() > 0 && requestid.values != null && !requestid.values[0]?.isEmpty()) {
    MDC.put("requestid", requestid.values[0]);
    logger.info("set requestid to " + requestid.values[0]);
}else {
    def uuid = java.util.UUID.randomUUID().toString();
    MDC.put("requestid", uuid);
    logger.info("set requestid to " + uuid);
}
return next.handle(context, request);